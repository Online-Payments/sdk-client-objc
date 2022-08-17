//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OPBasicPaymentProducts.h"

@interface OPPaymentProductsTestCase : XCTestCase

@property (strong, nonatomic) OPBasicPaymentProducts *products;

@end

@implementation OPPaymentProductsTestCase

- (void)setUp
{
    [super setUp];
    self.products = [[OPBasicPaymentProducts alloc] init];
}

- (void)testHasAccountsOnFileTrue
{
    OPAccountOnFile *account = [[OPAccountOnFile alloc] init];
    OPBasicPaymentProduct *product = [[OPBasicPaymentProduct alloc] init];
    [product.accountsOnFile.accountsOnFile addObject:account];
    [self.products.paymentProducts addObject:product];
    XCTAssertTrue([self.products hasAccountsOnFile] == YES, @"Payment products should have an account on file");
}

- (void)testHasAccountsOnFileFalse
{
    XCTAssertTrue([self.products hasAccountsOnFile] == NO, @"Payment products should not have an account on file");
}

- (void)testAccountsOnFile
{
    OPAccountOnFile *account = [[OPAccountOnFile alloc] init];
    OPBasicPaymentProduct *product = [[OPBasicPaymentProduct alloc] init];
    [product.accountsOnFile.accountsOnFile addObject:account];
    [self.products.paymentProducts addObject:product];
    NSArray *accountsOnFile = self.products.accountsOnFile;
    XCTAssertTrue(accountsOnFile.count == 1, @"Unexpected number of accounts on file");
    XCTAssertTrue(accountsOnFile[0] == account, @"Account on file that was added is not returned");
}

- (void)testPaymentProductWithIdentifierExisting
{
    OPBasicPaymentProduct *product = [[OPBasicPaymentProduct alloc] init];
    product.identifier = @"1";
    [self.products.paymentProducts addObject:product];
    XCTAssertTrue([self.products paymentProductWithIdentifier:@"1"] == product, @"Unexpected payment product retrieved");
}

- (void)testPaymentProductWithIdentifierNonExisting
{
    OPBasicPaymentProduct *product = [[OPBasicPaymentProduct alloc] init];
    product.identifier = @"1";
    [self.products.paymentProducts addObject:product];
    XCTAssertTrue([self.products paymentProductWithIdentifier:@"X"] == nil, @"Retrieved a payment product that has not been added");
}

- (void)testSort
{
    OPBasicPaymentProduct *product1 = [[OPBasicPaymentProduct alloc] init];
    product1.displayHintsList.firstObject.displayOrder = 100;
    [self.products.paymentProducts addObject:product1];
    OPBasicPaymentProduct *product2 = [[OPBasicPaymentProduct alloc] init];
    product2.displayHintsList.firstObject.displayOrder = 10;
    [self.products.paymentProducts addObject:product2];
    OPBasicPaymentProduct *product3 = [[OPBasicPaymentProduct alloc] init];
    product3.displayHintsList.firstObject.displayOrder = 99;
    [self.products.paymentProducts addObject:product3];
    [self.products sort];
    NSUInteger displayOrder = 0;
    for (int i = 0; i < 3; ++i) {
        OPBasicPaymentProduct *product = self.products.paymentProducts[i];
        if (displayOrder > product.displayHintsList.firstObject.displayOrder) {
            XCTFail(@"Products are not sorted");
        }
        displayOrder = product.displayHintsList.firstObject.displayOrder;
    }
}

@end
