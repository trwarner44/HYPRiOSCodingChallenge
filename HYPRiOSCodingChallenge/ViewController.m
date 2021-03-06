//
//  ViewController.m
//  HYPRiOSCodingChallenge
//
//  Created by Thomas Warner on 9/15/20.
//  Copyright © 2020 Thomas Warner. All rights reserved.
//

#import "ViewController.h"
#import "CustomInsetTextField.h"
#import "CustomInsetLabel.h"
#import "QueryManager.h"
#import "School.h"

@interface ViewController ()

@end

@implementation ViewController

UIScrollView *scrollView;
UIStackView *stackView;
UILabel *nextSchoolTitleLabel;
CustomInsetTextField *textField;
UIButton *button;
UILabel *currentSchoolTitleLabel;
CustomInsetLabel *currentSchoolDescriptionLabel;
UILabel *cacheTitleLabel;
NSMutableArray<CustomInsetLabel*> *cachedSchoolLabels;
UIView *currentSchoolBackgroundView;
UIView *cacheBackgroundView;
CAGradientLayer *gradientLayer;
QueryManager *queryManager;
const CGFloat spacing = 20;
const int maxCacheSize = 10;
NSMutableArray<School*> *cachedSchools;

// MARK: - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
    [self anchorSubviews];
    [self styleSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    gradientLayer.frame = self.view.frame;
}

// MARK: - Button Handlers
- (void)handleButton {
    NSString *text = textField.text;
    [self handleSchool:text completion:^(School *school) {
        //update UI
    }];

}

-(void)handleSchool:(NSString*)text completion: (void(^)(School*))callback {
    NSInteger intId = [text integerValue];
    NSString *dbn = [QueryManager dbnFor:intId];
    if ((intId == 0 && [text isEqualToString:@"0"]==false)) {
        NSLog(@"text is a string %@", text);
        [self presentErrorAlert];
    } else if (dbn == nil) {
        NSLog(@"text is out of dbn range");
        [self presentErrorAlert];
    } else {
        __block NSUInteger cachedSchoolIndex = -1;
        NSUInteger index = 0;
        for (School *school in cachedSchools) {
            if ([school.dbn isEqualToString:dbn]) {
                cachedSchoolIndex = index;
                break;
            }
            index++;
        }
        if (cachedSchoolIndex == -1) {
            NSLog(@"Fetching school with id: %ld, cache size before fetch: %lu", (long)intId, (unsigned long)cachedSchools.count);
            [QueryManager fetchSchool:dbn completion:^(School* school) {
                school.schoolId = intId;
                NSString *labelText = [NSString stringWithFormat: @"School Name: %@\ndbn: %@\nid: %d", school.schoolName, school.dbn, school.schoolId];
                currentSchoolDescriptionLabel.text = labelText;
                [cachedSchools addObject:school];
                if (cachedSchools.count > maxCacheSize) {
                    NSLog(@"dropping %@ from the cache", cachedSchools[0].schoolName);
                    [cachedSchools removeObjectAtIndex:0];
                }
                callback(school);
                [self showOrHideCachLabels];
                [UIView animateWithDuration:0.3 animations:^{
                    [self.view layoutIfNeeded];
                }];
            }];
        } else {
            NSLog(@"Using cached school");
            School *school = cachedSchools[cachedSchoolIndex];
            [cachedSchools removeObjectAtIndex:cachedSchoolIndex];
            [cachedSchools addObject:school];
            [self showOrHideCachLabels];
            callback(school);
            [UIView animateWithDuration:0.3 animations:^{
                [self.view layoutIfNeeded];
            }];
        }
    }
}

// MARK: - Init Subviews
- (void)initSubviews {
    gradientLayer = [CAGradientLayer layer];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    nextSchoolTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    textField = [[CustomInsetTextField alloc] initWithFrame:CGRectZero];
    button = [[UIButton alloc] initWithFrame:CGRectZero];
    currentSchoolTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    currentSchoolDescriptionLabel = [[CustomInsetLabel alloc] initWithFrame:CGRectZero];
    cacheTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    cachedSchoolLabels = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < maxCacheSize; ++i) {
        UILabel *label = [[CustomInsetLabel alloc] initWithFrame:CGRectZero];
        label.text = @"test label";
        [cachedSchoolLabels addObject:label];
    }
    NSMutableArray *subviews = [[NSMutableArray alloc] initWithObjects:
                                nextSchoolTitleLabel,
                                textField,
                                button,
                                currentSchoolTitleLabel,
                                currentSchoolDescriptionLabel,
                                cacheTitleLabel,
                                nil];
    for (UILabel *label in cachedSchoolLabels) {
        [subviews addObject:label];
    }
    stackView = [[UIStackView alloc] initWithArrangedSubviews: subviews];
    queryManager = [[QueryManager alloc] init];
    cacheBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    currentSchoolBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    cacheBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    cachedSchools = [[NSMutableArray alloc] init];
}

// MARK: - Anchor Subviews
- (void)anchorSubviews {
    [self.view addSubview:scrollView];
    scrollView.translatesAutoresizingMaskIntoConstraints = false;
    [scrollView.leadingAnchor constraintEqualToAnchor: self.view.leadingAnchor].active = true;
    [scrollView.topAnchor constraintEqualToAnchor: self.view.topAnchor].active = true;
    [scrollView.trailingAnchor constraintEqualToAnchor: self.view.trailingAnchor].active = true;
    [scrollView.bottomAnchor constraintEqualToAnchor: self.view.bottomAnchor].active = true;

    [scrollView addSubview:stackView];
    stackView.translatesAutoresizingMaskIntoConstraints = false;
    [stackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:spacing].active = true;
    [stackView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-spacing].active = true;
    [stackView.topAnchor constraintEqualToAnchor:scrollView.topAnchor constant:spacing].active = true;
    [stackView.bottomAnchor constraintEqualToAnchor:scrollView.bottomAnchor constant:-spacing*3].active = true;
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = spacing;
    [stackView setCustomSpacing:spacing/2 afterView:nextSchoolTitleLabel];
    [stackView setCustomSpacing:spacing/2 afterView:currentSchoolTitleLabel];
    [stackView setCustomSpacing:spacing/2 afterView:cacheTitleLabel];
    
    [scrollView insertSubview:currentSchoolBackgroundView atIndex:0];
    currentSchoolBackgroundView.translatesAutoresizingMaskIntoConstraints = false;
    [currentSchoolBackgroundView.topAnchor constraintEqualToAnchor:currentSchoolDescriptionLabel.topAnchor].active = true;
    [currentSchoolBackgroundView.leadingAnchor constraintEqualToAnchor:currentSchoolDescriptionLabel.leadingAnchor].active = true;
    [currentSchoolBackgroundView.trailingAnchor constraintEqualToAnchor:currentSchoolDescriptionLabel.trailingAnchor].active = true;
    [currentSchoolBackgroundView.bottomAnchor constraintEqualToAnchor:currentSchoolDescriptionLabel.bottomAnchor].active = true;
    
    [scrollView insertSubview:cacheBackgroundView atIndex:0];
    cacheBackgroundView.translatesAutoresizingMaskIntoConstraints = false;
    [cacheBackgroundView.topAnchor constraintEqualToAnchor:cachedSchoolLabels[0].topAnchor].active = true;
    [cacheBackgroundView.leadingAnchor constraintEqualToAnchor:cachedSchoolLabels[0].leadingAnchor].active = true;
    [cacheBackgroundView.trailingAnchor constraintEqualToAnchor:cachedSchoolLabels[0].trailingAnchor].active = true;
    [cacheBackgroundView.bottomAnchor constraintEqualToAnchor:cachedSchoolLabels[maxCacheSize-1].bottomAnchor].active = true;
    [self showOrHideCachLabels];
}

// MARK: - StyleSubviews
- (void)styleSubviews {
    [self styleGradientLayer]; //Helper function
//    UIColor* darkGrayColor = [[UIColor alloc] initWithWhite:0.2 alpha:1.0];
    UIColor *darkGrayColor = [[UIColor alloc] initWithRed:4.0/255.0 green:15.0/255.0 blue:56.0/255.0 alpha:1];
    self.view.backgroundColor = UIColor.blueColor;
    UIFont *headerFont = [UIFont boldSystemFontOfSize:22];
    UIColor *textColor = UIColor.whiteColor;
    
    scrollView.alwaysBounceVertical = true;
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    nextSchoolTitleLabel.font = headerFont;
    nextSchoolTitleLabel.textColor = textColor;
    nextSchoolTitleLabel.text = @"Next School";
    
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"School Index" attributes:@{
        NSForegroundColorAttributeName: [[UIColor alloc] initWithWhite:0.5 alpha:1.0]
    }];
    textField.tintColor = textColor;
    textField.textColor = textColor;
    textField.backgroundColor = darkGrayColor;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.layer.cornerRadius = 6;
    textField.layer.masksToBounds = true;
    textField.delegate = self;

    
    [button setTitle: @"Load School" forState: UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    button.backgroundColor = darkGrayColor;
    button.layer.cornerRadius = 6;
    button.layer.masksToBounds = true;
    [button addTarget:self action:@selector(handleButton) forControlEvents:UIControlEventTouchUpInside];
    
    currentSchoolBackgroundView.backgroundColor = darkGrayColor;
    currentSchoolBackgroundView.layer.cornerRadius = 6;
    currentSchoolBackgroundView.layer.masksToBounds = true;
    
    cacheBackgroundView.backgroundColor = darkGrayColor;
    cacheBackgroundView.layer.cornerRadius = 6;
    cacheBackgroundView.layer.masksToBounds = true;
    
    currentSchoolTitleLabel.text = @"Current School";
    [currentSchoolTitleLabel setFont:headerFont];
    currentSchoolTitleLabel.textColor = textColor;
    
    currentSchoolDescriptionLabel.numberOfLines = 0;
    currentSchoolDescriptionLabel.text = @"None";
    currentSchoolDescriptionLabel.textColor = textColor;
    
    cacheTitleLabel.text = @"School Cache";
    [cacheTitleLabel setFont:headerFont];
    cacheTitleLabel.textColor = textColor;
    
    for (UILabel *label in cachedSchoolLabels) {
        label.textColor = textColor;
    }
}



// MARK: - Helper Functions

-(void)showOrHideCachLabels {
    // schools need added to bottom of labels
    // so we'll iterate forward through the schools but backward
    // through the labels
    NSInteger currentSchoolIndex = 0;
    NSInteger currentLabelIndex = cachedSchoolLabels.count - 1;
    while (currentSchoolIndex < maxCacheSize) {
        CustomInsetLabel *label = cachedSchoolLabels[currentLabelIndex];
        if (currentSchoolIndex < cachedSchools.count) {
            School *school = cachedSchools[currentSchoolIndex];
            label.text = [NSString stringWithFormat:@"%d: %@", school.schoolId, school.schoolName ];
            [label setHidden:false];
        } else {
            [label setHidden:true];
        }
        currentSchoolIndex++;
        currentLabelIndex --;
    }
}

- (void)styleGradientLayer {
    UIColor *blueColor = [[UIColor alloc] initWithRed:18.0f/255.0f green:117.0f/255.0f blue:187.0f/255.0f alpha:1];
    UIColor *purpleColor = [[UIColor alloc] initWithRed:149.0f/255.0f green:65.0f/255.0f blue:193.0f/255.0f alpha:1];
    NSArray *colors =  [NSArray arrayWithObjects:(id) blueColor.CGColor , purpleColor.CGColor, nil];

    NSNumber *topStop = [NSNumber numberWithFloat:0.0];
    NSNumber *bottomStop = [NSNumber numberWithFloat:1.0];

    NSArray *locations = [NSArray arrayWithObjects: topStop, bottomStop, nil];
    gradientLayer.colors = colors;
    gradientLayer.locations = locations;

    [self.view.layer insertSublayer:gradientLayer atIndex:0];
}

-(void)presentErrorAlert {
    UIAlertController* alertVC = [UIAlertController alertControllerWithTitle:@"Uh-oh!"
                               message:@"Please input a number from 0 to 439"
                               preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {}];
    [alertVC addAction:okAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self handleButton];
    return YES;
}

@end
