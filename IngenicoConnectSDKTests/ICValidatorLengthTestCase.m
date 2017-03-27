//
//  ICValidatorLengthTestCase.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <IngenicoConnectSDK/ICValidatorLength.h>

@interface ICValidatorLengthTestCase : XCTestCase

@property (strong, nonatomic) ICValidatorLength *validator;

@end

@implementation ICValidatorLengthTestCase

- (void)setUp
{
    [super setUp];
    self.validator = [[ICValidatorLength alloc] init];
    self.validator.maxLength = 3;
    self.validator.minLength = 1;
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testValidateCorrect1
{
    [self.validator validate:@"1"];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid value considered invalid");
}

- (void)testValidateCorrect2
{
    [self.validator validate:@"12"];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid value considered invalid");
}

- (void)testValidateCorrect3
{
    [self.validator validate:@"123"];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid value considered invalid");
}

- (void)testValidateIncorrect1
{
    [self.validator validate:@""];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid value considered valid");
}

- (void)testValidateIncorrect2
{
    [self.validator validate:@"1234"];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid value considered valid");
}

@end
