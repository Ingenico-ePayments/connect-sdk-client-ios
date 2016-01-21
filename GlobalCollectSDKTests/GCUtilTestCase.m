//
//  GCUtilTestCase.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 17/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCUtil.h"
#import "GCBase64.h"

@interface GCUtilTestCase : XCTestCase

@property (strong, nonatomic) GCUtil *util;
@property (strong, nonatomic) GCBase64 *base64;

@end

@implementation GCUtilTestCase

- (void)setUp
{
    [super setUp];
    self.util = [[GCUtil alloc] init];
    self.base64 = [[GCBase64 alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testBase64EncodedClientMetaInfo;
{
    NSString *info = [self.util base64EncodedClientMetaInfo];
    NSData *decodedInfo = [self.base64 decode:info];
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:decodedInfo options:0 error:NULL];
    XCTAssertTrue([[JSON objectForKey:@"deviceBrand"] isEqualToString:@"Apple"] == YES, @"Incorrect device brand in meta info");
}

- (void)testBase64EncodedClientMetaInfoWithAddedData;
{
    NSString *info = [self.util base64EncodedClientMetaInfoWithAddedData:@{@"test": @"value"}];
    NSData *decodedInfo = [self.base64 decode:info];
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:decodedInfo options:0 error:NULL];
    XCTAssertTrue([[JSON objectForKey:@"test"] isEqualToString:@"value"] == YES, @"Incorrect value for added key in meta info");
}

@end
