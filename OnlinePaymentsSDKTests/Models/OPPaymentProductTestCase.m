//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OPPaymentProduct.h"

@interface OPPaymentProductTestCase : XCTestCase

@property (strong, nonatomic) OPPaymentProduct *paymentProduct;
@property (strong, nonatomic) OPPaymentProductField *field;

@end

@implementation OPPaymentProductTestCase

- (void)setUp
{
    [super setUp];
    self.paymentProduct = [[OPPaymentProduct alloc] init];
    self.field = [[OPPaymentProductField alloc] init];
    self.field.identifier = @"1";
    [self.paymentProduct.fields.paymentProductFields addObject:self.field];
}

- (void)testPaymentProductFieldWithIdExists
{
    OPPaymentProductField *field = [self.paymentProduct paymentProductFieldWithId:@"1"];
    XCTAssertEqual(field, self.field, @"Retrieved field is unequal to added field");
}

- (void)testPaymentProductFieldWithIdNil
{
    OPPaymentProductField *field = [self.paymentProduct paymentProductFieldWithId:@"X"];
    XCTAssertTrue(field == nil, @"Retrieved a field while no field should be returned");
}

@end
