//
//  GCC2SCommunicatorConfigurationTestCase.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 17/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCC2SCommunicatorConfiguration.h"
#import "GCStubUtil.h"

@interface GCC2SCommunicatorConfigurationTestCase : XCTestCase

@property (strong, nonatomic)GCC2SCommunicatorConfiguration *configuration;
@property (strong, nonatomic)GCStubUtil *util;

@end

@implementation GCC2SCommunicatorConfigurationTestCase

- (void)setUp
{
    [super setUp];
    self.util = [[GCStubUtil alloc] init];
    self.configuration = [[GCC2SCommunicatorConfiguration alloc] initWithClientSessionId:@"" customerId:@"" region:GCRegionEU environment:GCSandbox util:self.util];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testBaseURL
{
    XCTAssertTrue([[self.configuration baseURL] isEqualToString:@"c2sbaseurlbyregion"] == YES, @"Unexpected base URL");
}

- (void)testAssetsBaseURL
{
    XCTAssertTrue([[self.configuration assetsBaseURL] isEqualToString:@"assetsbaseurlbyregion"] == YES, @"Unexpected assets base URL");
}

- (void)testBase64EncodedClientMetaInfo
{
    XCTAssertTrue([[self.configuration base64EncodedClientMetaInfo] isEqualToString:@"base64encodedclientmetainfo"] == YES, @"Unexpected encoded client meta info");
}

@end
