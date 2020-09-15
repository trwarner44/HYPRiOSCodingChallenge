//
//  ViewController.m
//  HYPRiOSCodingChallenge
//
//  Created by Thomas Warner on 9/15/20.
//  Copyright © 2020 Thomas Warner. All rights reserved.
//

#import "ViewController.h"
#import "CustomInsetTextField.h"
#import "QueryManager.h"
//#import "QueryManager.m"

@interface ViewController ()

@end

@implementation ViewController

UIScrollView *scrollView;
UIStackView *stackView;
CustomInsetTextField *textField;
UIButton *button;
CAGradientLayer *gradientLayer;
QueryManager *queryManager;

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
    NSInteger *intId = [text integerValue];
    NSString *dbn = [QueryManager dbnFor:intId];
    NSLog(@"dbn: %@", dbn);
    
    [QueryManager fetchSchool:dbn];
}

// MARK: - Init Subviews
- (void)initSubviews {
    gradientLayer = [CAGradientLayer layer];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    textField = [[CustomInsetTextField alloc] initWithFrame:CGRectZero];
    stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    button = [[UIButton alloc] initWithFrame:CGRectZero];
    queryManager = [[QueryManager alloc] init];
}

// MARK: - Anchor Subviews
- (void)anchorSubviews {
    [self.view addSubview:scrollView];
    scrollView.translatesAutoresizingMaskIntoConstraints = false;
    [scrollView.leadingAnchor constraintEqualToAnchor: self.view.leadingAnchor].active = true;
    [scrollView.topAnchor constraintEqualToAnchor: self.view.topAnchor].active = true;
    [scrollView.trailingAnchor constraintEqualToAnchor: self.view.trailingAnchor].active = true;
    [scrollView.bottomAnchor constraintEqualToAnchor: self.view.bottomAnchor].active = true;

    [stackView addArrangedSubview:textField];
    [stackView addArrangedSubview:button];
    
    [scrollView addSubview:stackView];
    stackView.translatesAutoresizingMaskIntoConstraints = false;
    [stackView.widthAnchor constraintEqualToAnchor: self.view.widthAnchor multiplier:0.8].active = true;
    [stackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
    [stackView.topAnchor constraintEqualToAnchor:scrollView.topAnchor constant:25].active = true;
    [stackView.bottomAnchor constraintEqualToAnchor:scrollView.bottomAnchor constant:25].active = true;
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = 16;
    

}

// MARK: - StyleSubviews
- (void)styleSubviews {
    [self styleGradientLayer]; //Helper function
    UIColor* darkGrayColor = [[UIColor alloc] initWithWhite:0.2 alpha:1.0];
    self.view.backgroundColor = UIColor.blueColor;
    
    scrollView.alwaysBounceVertical = true;
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"School Index" attributes:@{
        NSForegroundColorAttributeName: [[UIColor alloc] initWithWhite:0.5 alpha:1.0]
    }];
    textField.tintColor = UIColor.whiteColor;
    textField.textColor = UIColor.whiteColor;
    textField.backgroundColor = darkGrayColor;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.layer.cornerRadius = 6;
    textField.layer.masksToBounds = true;

    
    [button setTitle: @"Button" forState: UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    button.backgroundColor = darkGrayColor;
    button.layer.cornerRadius = 6;
    button.layer.masksToBounds = true;
    [button addTarget:self action:@selector(handleButton) forControlEvents:UIControlEventTouchUpInside];
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



@end
