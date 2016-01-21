//
//  GCBase64TestCase.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 16/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCBase64.h"

@interface GCBase64TestCase : XCTestCase

@property (strong, nonatomic) GCBase64 *base64;

@end

@implementation GCBase64TestCase

- (void)setUp
{
    [super setUp];
    self.base64 = [[GCBase64 alloc] init];
}

- (void)tearDown
{
    [super tearDown];
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
