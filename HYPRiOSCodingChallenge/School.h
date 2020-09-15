//
//  School.h
//  HYPRiOSCodingChallenge
//
//  Created by Thomas Warner on 9/15/20.
//  Copyright © 2020 Thomas Warner. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface School : NSObject

@property (strong, nonatomic) NSString *dbn;
@property (strong, nonatomic) NSString *schoolName;
@property (assign, nullable, nonatomic) NSInteger *schoolId;

- (instancetype) init: (NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
