//
//  GCValidatorLengthTestCase.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 16/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCValidatorLength.h"

@interface GCValidatorLengthTestCase : XCTestCase

@property (strong, nonatomic) GCValidatorLength *validator;

@end

@implementation GCValidatorLengthTestCase

- (void)setUp
{
    [super setUp];
    self.validator = [[GCValidatorLength alloc] init];
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
