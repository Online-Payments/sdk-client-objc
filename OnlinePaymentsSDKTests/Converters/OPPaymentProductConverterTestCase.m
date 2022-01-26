//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <XCTest/XCTest.h>
#import "OPPaymentProductConverter.h"
#import "OPValidator.h"
#import "OPValidatorLength.h"
#import "OPAccountOnFileAttribute.h"

@interface OPPaymentProductConverterTestCase : XCTestCase

@property (strong, nonatomic) OPPaymentProductConverter *converter;

@end

@implementation OPPaymentProductConverterTestCase

- (void)setUp
{
    [super setUp];
    self.converter = [[OPPaymentProductConverter alloc] init];
}

- (void)testPaymentProductFromJSON
{
    NSString *paymentProductPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"paymentProduct" ofType:@"json"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *paymentProductData = [fileManager contentsAtPath:paymentProductPath];
    NSDictionary *paymentProductJSON = [NSJSONSerialization JSONObjectWithData:paymentProductData options:0 error:NULL];
    OPPaymentProduct *paymentProduct = [self.converter paymentProductFromJSON:paymentProductJSON];
    XCTAssertTrue(paymentProduct.fields.paymentProductFields.count == 3, @"Unexpected number of fields");
    OPPaymentProductField *field = paymentProduct.fields.paymentProductFields[0];
    XCTAssertTrue(field.dataRestrictions.isRequired == true, @"Unexpected value for 'isRequired'");
    XCTAssertTrue(field.displayHints.alwaysShow, @"Unexpected value for 'alwaysShow'");
    XCTAssertTrue(field.displayHints.displayOrder == 10, @"Unexpected value for 'displayOrder'");
    XCTAssertTrue(field.displayHints.obfuscate == false, @"Unexpected value for 'obfuscate'");
    XCTAssertTrue([field.identifier isEqualToString:@"cardNumber"] == YES, @"Unexpected identifier");
    XCTAssertTrue(field.dataRestrictions.validators.validators.count == 2, @"Unexpected number of validators");
    OPValidatorLength *validator = field.dataRestrictions.validators.validators[1];
    XCTAssertTrue(validator.maxLength == 19, @"Unexpected maximal length");
    OPAccountOnFile *accountOnFile = paymentProduct.accountsOnFile.accountsOnFile[0];
    XCTAssertTrue(accountOnFile.attributes.attributes.count == 4, @"Unexpected number of attributes of account on file");
    OPAccountOnFileAttribute *attribute = accountOnFile.attributes.attributes[0];
    XCTAssertTrue([attribute.key isEqualToString:@"cardholderName"], @"Unexpected key");
    XCTAssertTrue([attribute.value isEqualToString:@"Rob"], @"Unexpected value");
    XCTAssertTrue(attribute.status == OPMustWrite, @"Unexpected status");
    XCTAssertTrue([attribute.mustWriteReason isEqualToString:@"IN_THE_PAST"], @"Unexpected must-write reason");
    attribute = accountOnFile.attributes.attributes[1];
    XCTAssertTrue(attribute.mustWriteReason == nil, @"Must-write reason is not nil");
}

- (void)testPaymentProductWithMissingFieldsFromJSON
{
    NSString *paymentProductPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"paymentProductMissingFields" ofType:@"json"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *paymentProductData = [fileManager contentsAtPath:paymentProductPath];
    NSDictionary *paymentProductJSON = [NSJSONSerialization JSONObjectWithData:paymentProductData options:0 error:NULL];
    OPPaymentProduct *paymentProduct = [self.converter paymentProductFromJSON:paymentProductJSON];
    XCTAssertTrue(paymentProduct.fields.paymentProductFields.count == 3, @"Unexpected number of fields");
    OPPaymentProductField *field = paymentProduct.fields.paymentProductFields[0];
    NSLog(@"Field: %@", field);
    XCTAssertTrue(field.dataRestrictions.isRequired == true, @"Unexpected value for 'isRequired'");
    XCTAssertTrue(field.displayHints.displayOrder == 10, @"Unexpected value for 'displayOrder'");
    XCTAssertTrue(field.displayHints.obfuscate == false, @"Unexpected value for 'obfuscate'");
    XCTAssertTrue([field.identifier isEqualToString:@"cardNumber"] == YES, @"Unexpected identifier");
    XCTAssertTrue(field.dataRestrictions.validators.validators.count == 2, @"Unexpected number of validators");
    OPValidatorLength *validator = field.dataRestrictions.validators.validators[1];
    XCTAssertTrue(validator.maxLength == 19, @"Unexpected maximal length");
}

@end
