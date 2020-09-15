//
//  QueryManager.h
//  HYPRiOSCodingChallenge
//
//  Created by Thomas Warner on 9/15/20.
//  Copyright © 2020 Thomas Warner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "School.h"

NS_ASSUME_NONNULL_BEGIN

@interface QueryManager : NSObject

+ (void)fetchSchool:(NSString*)dbn completion: (void(^)(School*))callback;
+(nullable NSString*)dbnFor:(NSInteger)rowId;

@end


NS_ASSUME_NONNULL_END
