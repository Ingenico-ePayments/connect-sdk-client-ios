//
//  ICValidatorExpirationDateTestCase.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <IngenicoConnectSDK/ICValidatorExpirationDate.h>

@interface ICValidatorExpirationDateTestCase : XCTestCase

@property (strong, nonatomic) ICValidatorExpirationDate *validator;

@end

@implementation ICValidatorExpirationDateTestCase

- (void)setUp
{
    [super setUp];
    self.validator = [[ICValidatorExpirationDate alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testValid
{
    [self.validator validate:@"1249"];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid expiration date considered invalid");
}

- (void)testInvalid1
{
    [self.validator validate:@"aaaa"];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid expiration date considered valid");
}

- (void)testInvalid2
{
    [self.validator validate:@"1350"];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid expiration date considered valid");
}

- (void)testInvalid3
{
    [self.validator validate:@"0112"];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid expiration date considered valid");
}

// The date 12/50 is interpreted as December 1950.
- (void)testInvalid4
{
    [self.validator validate:@"1250"];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid expiration date considered valid");
}

@end
