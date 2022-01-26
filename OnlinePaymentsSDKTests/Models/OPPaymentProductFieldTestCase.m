//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OPPaymentProductField.h"
#import "OPValidatorLength.h"
#import "OPValidatorRange.h"

@interface OPPaymentProductFieldTestCase : XCTestCase

@property (strong, nonatomic) OPPaymentProductField *field;

@end

@implementation OPPaymentProductFieldTestCase

- (void)setUp
{
    [super setUp];
    self.field = [[OPPaymentProductField alloc] init];
    OPValidatorLength *length = [[OPValidatorLength alloc] init];
    length.minLength = 4;
    length.maxLength = 6;
    OPValidatorRange *range = [[OPValidatorRange alloc] init];
    range.minValue = 50;
    range.maxValue = 60;
    [self.field.dataRestrictions.validators.validators addObject:length];
    [self.field.dataRestrictions.validators.validators addObject:range];
}

- (void)testValidateValueCorrect
{
    [self.field validateValue:@"0055"];
    XCTAssertTrue(self.field.errors.count == 0, @"Unexpected errors after validation");
}

- (void)testValidateValueIncorrect
{
    [self.field validateValue:@"0"];
    XCTAssertTrue(self.field.errors.count == 2, @"Unexpected number of errors after validation");
}

@end
