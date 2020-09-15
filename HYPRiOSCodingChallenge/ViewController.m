//
//  ViewController.m
//  HYPRiOSCodingChallenge
//
//  Created by Thomas Warner on 9/15/20.
//  Copyright © 2020 Thomas Warner. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

UIScrollView *scrollView;
UIStackView *stackView;
UITextField *textField;
UIButton *button;

// MARK: - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    textField = [[UITextField alloc] initWithFrame:CGRectZero];
    stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    button = [[UIButton alloc] initWithFrame:CGRectZero];
    [self anchorSubviews];
    [self styleSubviews];

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
    
    self.view.backgroundColor = UIColor.blueColor;
    
    scrollView.alwaysBounceVertical = true;
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    textField.placeholder = @"Test";
    textField.backgroundColor = UIColor.lightGrayColor;
    textField.keyboardType = UIKeyboardTypeNumberPad;

    
    [button setTitle: @"Button" forState: UIControlStateNormal];
    [button setTitleColor:UIColor.brownColor forState:UIControlStateNormal];
    button.backgroundColor = UIColor.lightGrayColor;
}

- (void)styleGradientLayer {
    UIColor *blueColor = [[UIColor alloc] initWithRed:18.0f/255.0f green:117.0f/255.0f blue:187.0f/255.0f alpha:1];
    UIColor *purpleColor = [[UIColor alloc] initWithRed:149.0f/255.0f green:65.0f/255.0f blue:193.0f/255.0f alpha:1];
    NSArray *colors =  [NSArray arrayWithObjects:(id) blueColor.CGColor , purpleColor.CGColor, nil];

    NSNumber *topStop = [NSNumber numberWithFloat:0.0];
    NSNumber *bottomStop = [NSNumber numberWithFloat:1.0];

    NSArray *locations = [NSArray arrayWithObjects: topStop, bottomStop, nil];
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;

    headerLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:headerLayer atIndex:0];
}



@end
