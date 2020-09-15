//
//  CustomInsetLabel.m
//  HYPRiOSCodingChallenge
//
//  Created by Thomas Warner on 9/15/20.
//  Copyright © 2020 Thomas Warner. All rights reserved.
//

#import "CustomInsetLabel.h"

@implementation CustomInsetLabel

CGFloat topInset = 10;
CGFloat bottomInset = 10;
CGFloat leftInset = 10;
CGFloat rightInset = 10;

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = UIEdgeInsetsMake(topInset, leftInset, bottomInset, rightInset);
    CGRect newRect = UIEdgeInsetsInsetRect(rect, insets);
    [super drawTextInRect:newRect];
}

- (CGSize)intrinsicContentSize {
    CGSize intrinsicSuperViewContentSize = [super intrinsicContentSize] ;
    intrinsicSuperViewContentSize.height += topInset + bottomInset ;
    intrinsicSuperViewContentSize.width += leftInset + rightInset ;
    return intrinsicSuperViewContentSize ;
    
}

@end
