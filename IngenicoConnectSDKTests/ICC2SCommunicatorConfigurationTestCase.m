//
//  ICC2SCommunicatorConfigurationTestCase.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <IngenicoConnectSDK/ICC2SCommunicatorConfiguration.h>
#import <IngenicoConnectSDK/ICStubUtil.h>

@interface ICC2SCommunicatorConfigurationTestCase : XCTestCase

@property (strong, nonatomic)ICC2SCommunicatorConfiguration *configuration;
@property (strong, nonatomic)ICStubUtil *util;

@end

@implementation ICC2SCommunicatorConfigurationTestCase

- (void)setUp
{
    [super setUp];
    self.util = [[ICStubUtil alloc] init];
    self.configuration = [[ICC2SCommunicatorConfiguration alloc] initWithClientSessionId:@"" customerId:@"" region:ICRegionEU environment:ICSandbox util:self.util];
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
