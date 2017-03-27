//
//  ICUtilTestCase.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <IngenicoConnectSDK/ICUtil.h>
#import <IngenicoConnectSDK/ICBase64.h>

@interface ICUtilTestCase : XCTestCase

@property (strong, nonatomic) ICUtil *util;
@property (strong, nonatomic) ICBase64 *base64;

@end

@implementation ICUtilTestCase

- (void)setUp
{
    [super setUp];
    self.util = [[ICUtil alloc] init];
    self.base64 = [[ICBase64 alloc] init];
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
