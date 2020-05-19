//
//  ICC2SCommunicatorTestCase.m
//  IngenicoConnectSDK
//
//  Created by Leon Stemerdink on 22/04/2020.
//  Copyright © 2020 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import  "ICC2SCommunicator.h"

@interface ICC2SCommunicator (Testing)
- (NSString *)getIINDigitsFrom:(NSString *)partialCreditCardNumber;
@end

@interface ICC2SCommunicatorTestCase : XCTestCase
@end

@implementation ICC2SCommunicatorTestCase

- (void)testIINPartialCreditCardNumberLogic
{
    ICC2SCommunicator *communicator = [ICC2SCommunicator new];

    // Test that a partial CC of length 6 returns 6 IIN digits
    NSString *result1 = [communicator getIINDigitsFrom:@"123456"];
    XCTAssertTrue([result1 isEqualToString:@"123456"], @"Expected: '123456', actual: %@", result1);

    // Test that a partial CC of length 7 returns 6 IIN digits
    NSString *result2 = [communicator getIINDigitsFrom:@"1234567"];
    XCTAssertTrue([result2 isEqualToString:@"123456"], @"Expected: '123456', actual: %@", result2);

    // Test that a partial CC of length 8 returns 8 IIN digits
    NSString *result3 = [communicator getIINDigitsFrom:@"12345678"];
    XCTAssertTrue([result3 isEqualToString:@"12345678"], @"Expected: '12345678', actual: %@", result3);

    // Test that a partial CC of length less than 6 returns the provided digits
    NSString *result4 = [communicator getIINDigitsFrom:@"123"];
    XCTAssertTrue([result4 isEqualToString:@"123"], @"Expected: '123', actual: %@", result4);

    // Test that an empty string does not crash
    NSString *result5 = [communicator getIINDigitsFrom:@""];
    XCTAssertTrue([result5 isEqualToString:@""], @"Expected: '', actual: %@", result5);

    // Test that a partial CC longer than 8 returns 8 IIN digits
    NSString *result6 = [communicator getIINDigitsFrom:@"12345678112"];
    XCTAssertTrue([result6 isEqualToString:@"12345678"], @"Expected: '123456', actual: %@", result6);
}

@end
