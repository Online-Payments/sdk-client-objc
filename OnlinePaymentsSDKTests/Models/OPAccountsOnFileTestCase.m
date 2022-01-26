//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OPAccountsOnFile.h"
#import "OPAccountOnFile.h"

@interface OPAccountsOnFileTestCase : XCTestCase

@property (strong, nonatomic) OPAccountsOnFile *accountsOnFile;
@property (strong, nonatomic) OPAccountOnFile *account1;
@property (strong, nonatomic) OPAccountOnFile *account2;

@end

@implementation OPAccountsOnFileTestCase

- (void)setUp
{
    [super setUp];
    self.accountsOnFile = [[OPAccountsOnFile alloc] init];
    self.account1 = [[OPAccountOnFile alloc] init];
    self.account1.identifier = @"1";
    self.account2 = [[OPAccountOnFile alloc] init];
    self.account2.identifier = @"2";
    [self.accountsOnFile.accountsOnFile addObject:self.account1];
    [self.accountsOnFile.accountsOnFile addObject:self.account2];
}

- (void)testAccountOnFileWithIdentifier
{
    XCTAssertEqual([self.accountsOnFile accountOnFileWithIdentifier:@"1"], self.account1, @"Incorrect account on file retrieved");
}

@end
