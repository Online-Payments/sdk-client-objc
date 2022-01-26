//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OPLabelTemplate.h"
#import "OPLabelTemplateItem.h"

@interface OPLabelTemplateTestCase : XCTestCase

@property (strong, nonatomic) OPLabelTemplate *template;

@end

@implementation OPLabelTemplateTestCase

- (void)setUp
{
    [super setUp];
    self.template = [[OPLabelTemplate alloc] init];
    OPLabelTemplateItem *item1 = [[OPLabelTemplateItem alloc] init];
    item1.attributeKey = @"key1";
    item1.mask = @"mask1";
    OPLabelTemplateItem *item2 = [[OPLabelTemplateItem alloc] init];
    item2.attributeKey = @"key2";
    item2.mask = @"mask2";
    [self.template.labelTemplateItems addObject:item1];
    [self.template.labelTemplateItems addObject:item2];
    
}

- (void)testMaskForAttributeKey
{
    NSString *mask = [self.template maskForAttributeKey:@"key1"];
    XCTAssertTrue([mask isEqualToString:@"mask1"] == YES, @"Unexpected mask encountered");
}

@end
