//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <XCTest/XCTest.h>
#import "OPBase64.h"

@interface OPBase64TestCase : XCTestCase

@property (strong, nonatomic) OPBase64 *base64;

@end

@implementation OPBase64TestCase

- (void)setUp
{
    [super setUp];
    self.base64 = [[OPBase64 alloc] init];
}

- (void)testEncodeRevertable
{
    unsigned char buffer[4];
    buffer[0] = 0;
    buffer[1] = 255;
    buffer[2] = 43;
    buffer[3] = 1;
    NSData *input = [NSData dataWithBytes:buffer length:4];
    NSString *string = [self.base64 encode:input];
    NSData *output = [self.base64 decode:string];
    XCTAssertTrue([output isEqualToData:input], @"encoded and decoded data differs from the untransformed data");
}

- (void)testURLEncodeRevertable
{
    unsigned char buffer[4];
    buffer[0] = 0;
    buffer[1] = 255;
    buffer[2] = 43;
    buffer[3] = 1;
    NSData *input = [NSData dataWithBytes:buffer length:4];
    NSString *string = [self.base64 URLEncode:input];
    NSData *output = [self.base64 URLDecode:string];
    XCTAssertTrue([output isEqualToData:input], @"URL encoded and URL decoded data differs from the untransformed data");
}

- (void)testEncode
{
    NSData *data = [@"1234" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *output = [self.base64 encode:data];
    XCTAssertTrue([output isEqualToString:@"MTIzNA=="], @"Encoded data does not match expected output");
}

- (void)testURLEncode
{
    NSData *data = [@"1234" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *output = [self.base64 URLEncode:data];
    XCTAssertTrue([output isEqualToString:@"MTIzNA"], @"Encoded data does not match expected output");
}

@end
