//
//  HYPRiOSCodingChallengeTests.m
//  HYPRiOSCodingChallengeTests
//
//  Created by Thomas Warner on 9/17/20.
//  Copyright © 2020 Thomas Warner. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface HYPRiOSCodingChallengeTests : XCTestCase

@property ViewController *vc;

@end

@implementation HYPRiOSCodingChallengeTests

NSUInteger fetchSchoolIndex = 0;
NSArray *testIds;
NSMutableArray *finishedExpectations;

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _vc = UIApplication.sharedApplication.keyWindow.rootViewController;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}


- (void)testCacheSize {
    testIds = @[@22, @21, @7, @22, @22, @22, @7, @8, @9, @10, @11, @12, @33, @22, @2];
    _vc.textField.text = @"56";
    [self fetchNextSchool];
}

-(void)fetchNextSchool {
    NSMutableArray<XCTestExpectation*> *expectations = [[NSMutableArray alloc] init];
    NSString *description = [NSString stringWithFormat:@"%d", fetchSchoolIndex];
    XCTestExpectation *expectation = [self expectationWithDescription:description];
    [expectations addObject:expectation];
    _vc.textField.text = testIds[fetchSchoolIndex];
    
    [_vc handleSchool:testIds[fetchSchoolIndex] completion:^(School *school) {
        expectation.fulfill;
    }];
    [self waitForExpectations:expectations timeout:30];
    fetchSchoolIndex++;
    if (fetchSchoolIndex < testIds.count) {
        [self wait:1];
        [self fetchNextSchool];
    } else {
        NSLog(@"Test completed!");
    }

}

- (void)wait:(NSUInteger)interval {

    XCTestExpectation *expectation = [self expectationWithDescription:@"wait"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:interval handler:nil];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
