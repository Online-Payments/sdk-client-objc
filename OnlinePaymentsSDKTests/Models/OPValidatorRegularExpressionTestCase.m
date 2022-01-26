//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OPValidatorRegularExpression.h"

@interface OPValidatorRegularExpressionTestCase : XCTestCase

@property (strong, nonatomic) OPValidatorRegularExpression *validator;

@end

@implementation OPValidatorRegularExpressionTestCase

- (void)setUp
{
    [super setUp];
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"\\d{3}" options:0 error:NULL];
    self.validator = [[OPValidatorRegularExpression alloc] initWithRegularExpression:regularExpression];
}

- (void)testValidateCorrect
{
    [self.validator validate:@"123" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid value considered invalid");
}

- (void)testValidateIncorrect
{
    [self.validator validate:@"abc" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid value considered valid");
}

@end
