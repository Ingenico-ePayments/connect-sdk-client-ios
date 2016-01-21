//
//  GCJSONTestCase.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 16/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCJSON.h"

@interface GCJSONTestCase : XCTestCase

@property (strong, nonatomic) GCJSON *JSON;

@end

@implementation GCJSONTestCase

- (void)setUp
{
    [super setUp];
    self.JSON = [[GCJSON alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testDictionary
{
    NSDictionary *input = @{@"firstName": @"John", @"lastName": @"Doe"};
    NSDictionary *firstPair = @{@"key": @"firstName", @"value": @"John"};
    NSDictionary *secondPair = @{@"key": @"lastName", @"value": @"Doe"};
    NSArray *firstOutput = @[firstPair, secondPair];
    NSArray *secondOutput = @[secondPair, firstPair];
    NSData *firstData = [NSJSONSerialization dataWithJSONObject:firstOutput options:0 error:NULL];
    NSData *secondData = [NSJSONSerialization dataWithJSONObject:secondOutput options:0 error:NULL];
    NSString *firstExpectedOutput = [[NSString alloc] initWithData:firstData encoding:NSUTF8StringEncoding];
    NSString *secondExpectedOutput = [[NSString alloc] initWithData:secondData encoding:NSUTF8StringEncoding];
    NSString *actualOutput = [self.JSON keyValueJSONFromDictionary:input];
    XCTAssertTrue([firstExpectedOutput isEqualToString:actualOutput] || [secondExpectedOutput isEqualToString:actualOutput], @"Generated JSON differs from manually constructed JSON");
}

@end
