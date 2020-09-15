//
//  School.m
//  HYPRiOSCodingChallenge
//
//  Created by Thomas Warner on 9/15/20.
//  Copyright © 2020 Thomas Warner. All rights reserved.
//

#import "School.h"

@implementation School

- (instancetype) init: (NSDictionary *)dict {
    self = [super init];

    if (self) {
        NSString *dbn = dict[@"dbn"];
        NSString *schoolName = dict[@"school_name"];
        NSInteger schoolId = 0; //set from VC
        self.dbn = dbn;
        self.schoolName = schoolName;
        self.schoolId = &(schoolId);
    }
    return self;
}

@end
