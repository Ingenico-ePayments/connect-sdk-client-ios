//
//  ICValidatorRangeTestCase.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import  "ICValidatorRange.h"

@interface ICValidatorRangeTestCase : XCTestCase

@property (strong, nonatomic) ICValidatorRange *validator;

@end

@implementation ICValidatorRangeTestCase

- (void)setUp
{
    [super setUp];
    self.validator = [[ICValidatorRange alloc] init];
    self.validator.maxValue = 50;
    self.validator.minValue = 40;
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testValidateCorrect1
{
    [self.validator validate:@"40" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid value considered invalid");
}

- (void)testValidateCorrect2
{
    [self.validator validate:@"45" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid value considered invalid");
}
- (void)testValidateCorrect3
{
    [self.validator validate:@"50" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid value considered invalid");
}

- (void)testValidateIncorrect1
{
    [self.validator validate:@"aaa" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid value considered valid");
}

- (void)testValidateIncorrect2
{
    [self.validator validate:@"39" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid value considered valid");
}

- (void)testValidateIncorrect3
{
    [self.validator validate:@"51" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid value considered valid");
}

@end
