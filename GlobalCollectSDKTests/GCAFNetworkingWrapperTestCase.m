//
//  GCAFNetworkingWrapperTestCase.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 28/04/15.
//  Copyright (c) 2015 Global Collect Services B.V. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GCAFNetworkingWrapper.h"
#import "GCEnvironment.h"
#import "GCRegion.h"
#import "GCUtil.h"

@interface GCAFNetworkingWrapperTestCase : XCTestCase

@property (strong, nonatomic) GCAFNetworkingWrapper *wrapper;
@property (nonatomic) GCRegion region;
@property (nonatomic) GCEnvironment environment;
@property (strong, nonatomic) GCUtil *util;

@end

@implementation GCAFNetworkingWrapperTestCase

- (void)setUp
{
    [super setUp];
    
    self.util = [[GCUtil alloc] init];
    self.wrapper = [[GCAFNetworkingWrapper alloc] init];
    
    // The following value must be updated to reflect your situation for this test to succeed.
    self.environment = GCSandbox;
    self.region = GCRegionEU;
}

- (void)testPost
{
    NSString *baseURL = [self.util C2SBaseURLByRegion:self.region environment:self.environment];
    NSString *merchantId = @"1234";
    NSString *sessionsURL = [NSString stringWithFormat:@"%@/%@/sessions", baseURL, merchantId];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Response provided"];
    
    NSMutableIndexSet *additionalAcceptableStatusCodes = [[NSMutableIndexSet alloc] initWithIndex:401];
    [self.wrapper postResponseForURL:sessionsURL headers:nil withParameters:nil additionalAcceptableStatusCodes:additionalAcceptableStatusCodes succes:^(id responseObject) {
        [self assertErrorResponse:(NSDictionary *)responseObject expectation:expectation];
    } failure:^(NSError *error) {
        XCTFail(@"Unexpected failure while testing POST request: %@", [error localizedDescription]);
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout error: %@", [error localizedDescription]);
        }
    }];
}

- (void)testGet
{
    NSString *baseURL = [self.util C2SBaseURLByRegion:self.region environment:self.environment];
    NSString *customerId = @"1234";
    NSString *publicKeyURL = [NSString stringWithFormat:@"%@/%@/crypto/publickey", baseURL, customerId];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Response provided"];
    
    NSMutableIndexSet *additionalAcceptableStatusCodes = [[NSMutableIndexSet alloc] initWithIndex:401];
    [self.wrapper getResponseForURL:publicKeyURL headers:nil additionalAcceptableStatusCodes:additionalAcceptableStatusCodes succes:^(id responseObject) {
        [self assertErrorResponse:(NSDictionary *)responseObject expectation:expectation];
    } failure:^(NSError *error) {
        XCTFail(@"Unexpected failure while testing GET request: %@", [error localizedDescription]);
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout error: %@", [error localizedDescription]);
        }
    }];
}

- (void)assertErrorResponse:(NSDictionary *)errorResponse expectation:(XCTestExpectation *)expectation
{
    NSArray *errors = (NSArray *)[errorResponse objectForKey:@"errors"];
    NSDictionary *firstError = [errors objectAtIndex:0];
    XCTAssertEqual([[firstError objectForKey:@"code"] integerValue], 9002);
    XCTAssertTrue([[firstError objectForKey:@"message"] isEqualToString:@"MISSING_OR_INVALID_AUTHORIZATION"]);
    [expectation fulfill];
}

@end

