//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "OPPaymentProductFields.h"
#import "OPPaymentProductField.h"

@interface OPPaymentProductFieldsTestCase : XCTestCase

@property (strong, nonatomic) OPPaymentProductFields *fields;

@end

@implementation OPPaymentProductFieldsTestCase

- (void)setUp
{
    [super setUp];
    self.fields = [[OPPaymentProductFields alloc] init];
    OPPaymentProductField *field1 = [[OPPaymentProductField alloc] init];
    field1.displayHints.displayOrder = 1;
    OPPaymentProductField *field2 = [[OPPaymentProductField alloc] init];
    field2.displayHints.displayOrder = 100;
    OPPaymentProductField *field3 = [[OPPaymentProductField alloc] init];
    field3.displayHints.displayOrder = 4;
    OPPaymentProductField *field4 = [[OPPaymentProductField alloc] init];
    field4.displayHints.displayOrder = 50;
    OPPaymentProductField *field5 = [[OPPaymentProductField alloc] init];
    field5.displayHints.displayOrder = 3;
    [self.fields.paymentProductFields addObject:field1];
    [self.fields.paymentProductFields addObject:field2];
    [self.fields.paymentProductFields addObject:field3];
    [self.fields.paymentProductFields addObject:field4];
    [self.fields.paymentProductFields addObject:field5];
}

- (void)testSort
{
    [self.fields sort];
    NSInteger displayOrder = -1;
    for (OPPaymentProductField *field in self.fields.paymentProductFields) {
        if (displayOrder > field.displayHints.displayOrder) {
            XCTFail(@"Fields not sorted according to display order");
        }
        displayOrder = field.displayHints.displayOrder;
    }
}

@end
