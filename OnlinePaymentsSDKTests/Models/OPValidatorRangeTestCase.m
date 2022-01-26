//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OPValidatorRange.h"

@interface OPValidatorRangeTestCase : XCTestCase

@property (strong, nonatomic) OPValidatorRange *validator;

@end

@implementation OPValidatorRangeTestCase

- (void)setUp
{
    [super setUp];
    self.validator = [[OPValidatorRange alloc] init];
    self.validator.maxValue = 50;
    self.validator.minValue = 40;
}

- (void)testValidateCorrect1
{
    [self.validator validate:@"40" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid value considered invalid");
}

- (void)testValidateCorrect2
{
    [self.validator validate:@"45" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid value considered invalid");
}
- (void)testValidateCorrect3
{
    [self.validator validate:@"50" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid value considered invalid");
}

- (void)testValidateIncorrect1
{
    [self.validator validate:@"aaa" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid value considered valid");
}

- (void)testValidateIncorrect2
{
    [self.validator validate:@"39" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid value considered valid");
}

- (void)testValidateIncorrect3
{
    [self.validator validate:@"51" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid value considered valid");
}

@end
