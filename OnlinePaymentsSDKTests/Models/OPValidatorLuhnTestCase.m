//
//  OPValidatorLuhnTestCase.m
//  OnlinePaymentsSDK
//
//  Created for Online Payments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OPValidatorLuhn.h"

@interface OPValidatorLuhnTestCase : XCTestCase

@property (strong, nonatomic) OPValidatorLuhn *validator;

@end

@implementation OPValidatorLuhnTestCase

- (void)setUp
{
    [super setUp];
    self.validator = [[OPValidatorLuhn alloc] init];
}

- (void)testValidateCorrect
{
    [self.validator validate:@"4242424242424242" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid value considered invalid");
}

- (void)testValidateIncorrect
{
    [self.validator validate:@"1111" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid value considered valid");
}

@end
