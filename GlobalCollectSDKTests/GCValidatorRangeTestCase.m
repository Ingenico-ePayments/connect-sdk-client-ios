//
//  GCValidatorRangeTestCase.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 16/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCValidatorRange.h"

@interface GCValidatorRangeTestCase : XCTestCase

@property (strong, nonatomic) GCValidatorRange *validator;

@end

@implementation GCValidatorRangeTestCase

- (void)setUp
{
    [super setUp];
    self.validator = [[GCValidatorRange alloc] init];
    self.validator.maxValue = 50;
    self.validator.minValue = 40;
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testValidateCorrect1
{
    [self.validator validate:@"40"];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid value considered invalid");
}

- (void)testValidateCorrect2
{
    [self.validator validate:@"45"];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid value considered invalid");
}
- (void)testValidateCorrect3
{
    [self.validator validate:@"50"];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid value considered invalid");
}

- (void)testValidateIncorrect1
{
    [self.validator validate:@"aaa"];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid value considered valid");
}

- (void)testValidateIncorrect2
{
    [self.validator validate:@"39"];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid value considered valid");
}

- (void)testValidateIncorrect3
{
    [self.validator validate:@"51"];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid value considered valid");
}

@end
