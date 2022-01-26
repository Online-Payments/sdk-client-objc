//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OPValidatorFixedList.h"

@interface OPValidatorFixedListTestCase : XCTestCase

@property (strong, nonatomic) OPValidatorFixedList *validator;

@end

@implementation OPValidatorFixedListTestCase

- (void)setUp
{
    [super setUp];
    self.validator = [[OPValidatorFixedList alloc] initWithAllowedValues:@[@"1"]];
}

- (void)testValidateCorrect
{
    [self.validator validate:@"1" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid value considered invalid");
}

- (void)testValidateIncorrect
{
    [self.validator validate:@"X" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid value considered valid");
}

@end
