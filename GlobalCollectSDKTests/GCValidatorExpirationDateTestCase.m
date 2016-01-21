//
//  GCValidatorExpirationDateTestCase.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 16/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCValidatorExpirationDate.h"

@interface GCValidatorExpirationDateTestCase : XCTestCase

@property (strong, nonatomic) GCValidatorExpirationDate *validator;

@end

@implementation GCValidatorExpirationDateTestCase

- (void)setUp
{
    [super setUp];
    self.validator = [[GCValidatorExpirationDate alloc] init];
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
