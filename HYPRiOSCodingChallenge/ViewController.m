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

UITextField *_textField;

// MARK: - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _textField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self anchorSubviews];
    [self styleSubviews];

}

// MARK: - Anchor Subviews
- (void)anchorSubviews {
    _textField.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:_textField];
    
    [_textField.widthAnchor constraintEqualToAnchor: self.view.widthAnchor multiplier:0.8].active = true;
    [_textField.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [_textField.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:25].active = YES;
}

// MARK: - StyleSubviews
- (void)styleSubviews {
    _textField.placeholder = @"Test";
    _textField.backgroundColor = UIColor.lightGrayColor;
}



@end
