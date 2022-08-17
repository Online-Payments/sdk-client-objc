//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OPValidatorExpirationDate.h"

@interface OPValidatorExpirationDateTestCase : XCTestCase

@property (strong, nonatomic) OPValidatorExpirationDate *validator;
@property (strong, nonatomic) NSDate *now;
@property (strong, nonatomic) NSDate *futureDate;

@end

@interface OPValidatorExpirationDate (Testing)

- (BOOL)validateDateIsBetween:(NSDate *)now andFutureDate:(NSDate *)futureDate withDateToValidate:(NSDate *)dateToValidate;

@end

@implementation OPValidatorExpirationDateTestCase

- (void)setUp
{
    [super setUp];
    self.validator = [OPValidatorExpirationDate new];

    NSDateComponents *nowComponents = [[NSDateComponents alloc] init];
    nowComponents.year = 2018;
    nowComponents.month = 9;
    nowComponents.day = 23;
    nowComponents.hour = 6;
    nowComponents.minute = 33;
    nowComponents.second = 37;
    self.now = [[NSCalendar currentCalendar] dateFromComponents:nowComponents];

    NSDateComponents *futureDateComponents = [[NSDateComponents alloc] init];
    futureDateComponents.year = 2033;
    futureDateComponents.month = 9;
    futureDateComponents.day = 23;
    futureDateComponents.hour = 6;
    futureDateComponents.minute = 33;
    futureDateComponents.second = 37;
    self.futureDate = [[NSCalendar currentCalendar] dateFromComponents:futureDateComponents];
}

- (void)testValid
{
    [self.validator validate:@"1244" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid expiration date considered invalid");
}

- (void)testInvalidNonNumerical
{
    [self.validator validate:@"aaaa" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid expiration date considered valid");
}

- (void)testInvalidMonth
{
    [self.validator validate:@"1350" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid expiration date considered valid");
}

- (void)testInvalidYearTooEarly
{
    [self.validator validate:@"0112" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid expiration date considered valid");
}

- (void)testInvalidYearTooLate
{
    [self.validator validate:@"1299" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid expiration date considered valid");
}

- (void)testInvalidInputTooLong
{
    [self.validator validate:@"122044" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid expiration date considered valid");
}

- (void)testValidLowerSameMonthAndYear
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *nowComponents = [[NSDateComponents alloc] init];
    [nowComponents setYear:2018];
    [nowComponents setMonth:9];
    NSDate *testDate = [gregorianCalendar dateFromComponents:nowComponents];

    BOOL validationResult = [self.validator validateDateIsBetween:self.now andFutureDate:self.futureDate withDateToValidate:testDate];
    XCTAssertTrue(validationResult, @"Valid expiration date considered invalid");
}

- (void)testInValidLowerMonth
{
    NSDateComponents *nowComponents = [[NSDateComponents alloc] init];
    nowComponents.year = 2018;
    nowComponents.month = 8;
    NSDate *testDate = [[NSCalendar currentCalendar] dateFromComponents:nowComponents];

    BOOL validationResult = [self.validator validateDateIsBetween:self.now andFutureDate:self.futureDate withDateToValidate:testDate];
    XCTAssertFalse(validationResult, @"Invalid expiration date considered valid");
}

- (void)testInValidLowerYear
{
    NSDateComponents *nowComponents = [[NSDateComponents alloc] init];
    nowComponents.year = 2017;
    nowComponents.month = 9;
    NSDate *testDate = [[NSCalendar currentCalendar] dateFromComponents:nowComponents];

    BOOL validationResult = [self.validator validateDateIsBetween:self.now andFutureDate:self.futureDate withDateToValidate:testDate];
    XCTAssertFalse(validationResult, @"Invalid expiration date considered valid");
}

- (void)testValidUpperSameMonthAndYear
{
    NSDateComponents *nowComponents = [[NSDateComponents alloc] init];
    nowComponents.year = 2033;
    nowComponents.month = 9;
    NSDate *testDate = [[NSCalendar currentCalendar] dateFromComponents:nowComponents];

    BOOL validationResult = [self.validator validateDateIsBetween:self.now andFutureDate:self.futureDate withDateToValidate:testDate];
    XCTAssertTrue(validationResult, @"Valid expiration date considered invalid");
}

- (void)testValidUpperHigherMonthSameYear
{
    NSDateComponents *nowComponents = [[NSDateComponents alloc] init];
    nowComponents.year = 2033;
    nowComponents.month = 11;
    NSDate *testDate = [[NSCalendar currentCalendar] dateFromComponents:nowComponents];

    BOOL validationResult = [self.validator validateDateIsBetween:self.now andFutureDate:self.futureDate withDateToValidate:testDate];
    XCTAssertTrue(validationResult, @"Valid expiration date considered invalid");
}

- (void)testInValidUpperHigherYear
{
    NSDateComponents *nowComponents = [[NSDateComponents alloc] init];
    nowComponents.year = 2034;
    nowComponents.month = 1;
    NSDate *testDate = [[NSCalendar currentCalendar] dateFromComponents:nowComponents];

    BOOL validationResult = [self.validator validateDateIsBetween:self.now andFutureDate:self.futureDate withDateToValidate:testDate];
    XCTAssertFalse(validationResult, @"Invalid expiration date considered valid");
}

- (void)testInValidUpperMuchHigherYear
{
    NSDateComponents *testDateComponents = [[NSDateComponents alloc] init];
    testDateComponents.year = 2099;
    testDateComponents.month = 1;
    NSDate *testDate = [[NSCalendar currentCalendar] dateFromComponents:testDateComponents];

    BOOL validationResult = [self.validator validateDateIsBetween:self.now andFutureDate:self.futureDate withDateToValidate:testDate];
    XCTAssertFalse(validationResult, @"Invalid expiration date considered valid");
}

@end
