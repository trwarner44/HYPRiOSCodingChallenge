//
//  CustomInsetTextField.m
//  HYPRiOSCodingChallenge
//
//  Created by Thomas Warner on 9/15/20.
//  Copyright © 2020 Thomas Warner. All rights reserved.
//

#import "CustomInsetTextField.h"

@implementation CustomInsetTextField

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
     return CGRectInset(bounds, 10, 10);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
     return CGRectInset(bounds, 10, 10);
}
@end
