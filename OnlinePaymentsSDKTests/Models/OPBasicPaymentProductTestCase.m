//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "OPBasicPaymentProduct.h"

@interface OPBasicPaymentProductTestCase : XCTestCase

@property (strong, nonatomic) OPBasicPaymentProduct *product;
@property (strong, nonatomic) OPAccountsOnFile *accountsOnFile;
@property (strong, nonatomic) OPAccountOnFile *account1;
@property (strong, nonatomic) OPAccountOnFile *account2;

@end

@implementation OPBasicPaymentProductTestCase

- (void)setUp
{
    [super setUp];
    self.product = [[OPBasicPaymentProduct alloc] init];
    self.accountsOnFile = [[OPAccountsOnFile alloc] init];
    self.account1 = [[OPAccountOnFile alloc] init];
    self.account1.identifier = @"1";
    self.account2 = [[OPAccountOnFile alloc] init];
    self.account2.identifier = @"2";
    [self.accountsOnFile.accountsOnFile addObject:self.account1];
    [self.accountsOnFile.accountsOnFile addObject:self.account2];
    self.product.accountsOnFile = self.accountsOnFile;
}

- (void)testAccountOnFileWithIdentifier
{
    XCTAssertEqual([self.product accountOnFileWithIdentifier:@"1"], self.account1, @"Unexpected account on file retrieved");
}

@end
