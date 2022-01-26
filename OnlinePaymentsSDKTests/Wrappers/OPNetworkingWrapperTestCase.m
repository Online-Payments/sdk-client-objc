//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "OPNetworkingWrapper.h"
#import "OPUtil.h"

@interface OPNetworkingWrapperTestCase : XCTestCase

@property (strong, nonatomic) OPNetworkingWrapper *wrapper;
@property (strong, nonatomic) OPUtil *util;

@end

@implementation OPNetworkingWrapperTestCase

- (void)setUp
{
    [super setUp];
    
    self.util = [[OPUtil alloc] init];
    self.wrapper = [[OPNetworkingWrapper alloc] init];
}

- (void)ignore_testPost
{
    NSString *baseURL = @"example.com";
    NSString *merchantId = @"1234";
    NSString *sessionsURL = [NSString stringWithFormat:@"%@/%@/sessions", baseURL, merchantId];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Response provided"];
    
    NSMutableIndexSet *additionalAcceptableStatusCodes = [[NSMutableIndexSet alloc] initWithIndex:401];
    [self.wrapper postResponseForURL:sessionsURL headers:nil withParameters:nil additionalAcceptableStatusCodes:additionalAcceptableStatusCodes success:^(id responseObject) {
        [self assertErrorResponse:(NSDictionary *)responseObject expectation:expectation];
    } failure:^(NSError *error) {
        XCTFail(@"Unexpected failure while testing POST request: %@", [error localizedDescription]);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout error: %@", [error localizedDescription]);
        }
    }];
}

- (void)ignore_testGet
{
    NSString *baseURL = @"example.com";
    NSString *customerId = @"1234";
    NSString *publicKeyURL = [NSString stringWithFormat:@"%@/%@/crypto/publickey", baseURL, customerId];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Response provided"];
    
    NSMutableIndexSet *additionalAcceptableStatusCodes = [[NSMutableIndexSet alloc] initWithIndex:401];
    [self.wrapper getResponseForURL:publicKeyURL headers:nil additionalAcceptableStatusCodes:additionalAcceptableStatusCodes success:^(id responseObject) {
        [self assertErrorResponse:(NSDictionary *)responseObject expectation:expectation];
    } failure:^(NSError *error) {
        XCTFail(@"Unexpected failure while testing GET request: %@", [error localizedDescription]);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout error: %@", [error localizedDescription]);
        }
    }];
}

- (void)assertErrorResponse:(NSDictionary *)errorResponse expectation:(XCTestExpectation *)expectation
{
    NSArray *errors = (NSArray *)[errorResponse objectForKey:@"errors"];
    NSDictionary *firstError = [errors objectAtIndex:0];
    XCTAssertEqual([[firstError objectForKey:@"code"] integerValue], 9002);
    XCTAssertTrue([[firstError objectForKey:@"message"] isEqualToString:@"MISSING_OR_INVALID_AUTHORIZATION"]);
    [expectation fulfill];
}

@end
