//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <XCTest/XCTest.h>

#import "OPUtil.h"
#import "OPBase64.h"

@interface OPUtilTestCase : XCTestCase

@property (strong, nonatomic) OPUtil *util;
@property (strong, nonatomic) OPBase64 *base64;

@end

@implementation OPUtilTestCase

- (void)setUp
{
    [super setUp];
    self.util = [[OPUtil alloc] init];
    self.base64 = [[OPBase64 alloc] init];
}

- (void)testBase64EncodedClientMetaInfo;
{
    NSString *info = [self.util base64EncodedClientMetaInfoWithAppIdentifier:@"appIdentifier" ipAddress:@"ipAddress"];
    NSData *decodedInfo = [self.base64 decode:info];
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:decodedInfo options:0 error:NULL];
    XCTAssertTrue([[JSON objectForKey:@"deviceBrand"] isEqualToString:@"Apple"] == YES, @"Incorrect device brand in meta info");
}

- (void)testBase64EncodedClientMetaInfoWithAddedData;
{
    NSString *info = [self.util base64EncodedClientMetaInfoWithAppIdentifier:@"appIdentifier" ipAddress:@"ipAddress" addedData:@{@"test": @"value"}];
    NSData *decodedInfo = [self.base64 decode:info];
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:decodedInfo options:0 error:NULL];
    XCTAssertTrue([[JSON objectForKey:@"test"] isEqualToString:@"value"] == YES, @"Incorrect value for added key in meta info");
}

@end
