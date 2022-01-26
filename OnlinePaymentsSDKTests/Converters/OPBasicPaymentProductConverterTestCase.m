//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <XCTest/XCTest.h>
#import "OPBasicPaymentProductConverter.h"

@interface OPBasicPaymentProductConverterTestCase : XCTestCase

@property (strong, nonatomic) OPBasicPaymentProductConverter *converter;

@end

@implementation OPBasicPaymentProductConverterTestCase

- (void)setUp
{
    [super setUp];
    self.converter = [[OPBasicPaymentProductConverter alloc] init];
}

- (void)testBasicPaymentProductFromJSON
{
    NSString *paymentProductPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"paymentProduct" ofType:@"json"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *paymentProductData = [fileManager contentsAtPath:paymentProductPath];
    NSDictionary *paymentProductJSON = [NSJSONSerialization JSONObjectWithData:paymentProductData options:0 error:NULL];
    OPBasicPaymentProduct *paymentProduct = [self.converter basicPaymentProductFromJSON:paymentProductJSON];
    XCTAssertTrue([paymentProduct.identifier isEqualToString:@"1"] == YES, @"Payment product has an unexpected identifier");
    XCTAssertTrue(paymentProduct.allowsRecurring, @"Unexpected value for 'allowsRecurring'");
    XCTAssertTrue(paymentProduct.allowsTokenization, @"Unexpected value for 'allowsTokenization'");
    XCTAssertNotNil(paymentProduct.displayHints.logoPath, @"Display hints of payment product has no logo path");
    XCTAssertTrue(paymentProduct.accountsOnFile.accountsOnFile.count == 1, @"Unexpected number of accounts on file");
    OPAccountOnFile *accountOnFile = paymentProduct.accountsOnFile.accountsOnFile[0];
    XCTAssertTrue(accountOnFile.attributes.attributes.count == 4, @"Unexpected number of attributes in account on file");
}

@end
