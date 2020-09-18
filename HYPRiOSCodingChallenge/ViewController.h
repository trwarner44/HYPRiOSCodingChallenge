//
//  ViewController.h
//  HYPRiOSCodingChallenge
//
//  Created by Thomas Warner on 9/15/20.
//  Copyright © 2020 Thomas Warner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomInsetTextField.h"
#import "School.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) CustomInsetTextField *textField;
@property (weak, nonatomic) UILabel *currentSchoolTitleLabel;

-(void)handleSchool:(NSString*)text completion: (void(^)(School*))callback;

@end

