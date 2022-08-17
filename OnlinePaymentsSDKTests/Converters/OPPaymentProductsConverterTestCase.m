//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <XCTest/XCTest.h>
#import "OPBasicPaymentProductsConverter.h"

@interface OPPaymentProductsConverterTestCase : XCTestCase

@property (strong, nonatomic) OPBasicPaymentProductsConverter *converter;

@end

@implementation OPPaymentProductsConverterTestCase

- (void)setUp
{
    [super setUp];
    self.converter = [[OPBasicPaymentProductsConverter alloc] init];
}

- (void)testPaymentProductsFromJSON
{
    NSString *paymentProductsPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"paymentProducts" ofType:@"json"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *paymentProductsData = [fileManager contentsAtPath:paymentProductsPath];
    NSDictionary *paymentProductsJSON = [NSJSONSerialization JSONObjectWithData:paymentProductsData options:0 error:NULL];
    OPBasicPaymentProducts *paymentProducts = [self.converter paymentProductsFromJSON:[paymentProductsJSON objectForKey:@"paymentProducts"]];
    if (paymentProducts.paymentProducts.count != 24) {
        XCTFail(@"Wrong number of payment products.");
    }
    for (OPBasicPaymentProduct *product in paymentProducts.paymentProducts) {
        XCTAssertNotNil(product.identifier, @"Payment product has no identifier");
        XCTAssertNotNil(product.displayHintsList, @"Payment product has no displayHints");
        XCTAssertNotNil(product.displayHintsList.firstObject.logoPath, @"Payment product has no logo path in displayHints");
        if (product.accountsOnFile != nil) {
            for (OPAccountOnFile *accountOnFile in product.accountsOnFile.accountsOnFile) {
                XCTAssertNotNil(accountOnFile.attributes, @"Account on file has no attributes");
                XCTAssertNotNil(accountOnFile.displayHints, @"Account on file has no displayHints");
            }
        }
    }
}

@end
