//
//  GCValidatorLuhnTestCase.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 16/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCValidatorLuhn.h"

@interface GCValidatorLuhnTestCase : XCTestCase

@property (strong, nonatomic) GCValidatorLuhn *validator;

@end

@implementation GCValidatorLuhnTestCase

- (void)setUp
{
    [super setUp];
    self.validator = [[GCValidatorLuhn alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testValidateCorrect
{
    [self.validator validate:@"4242424242424242"];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid value considered invalid");
}

- (void)testValidateIncorrect
{
    [self.validator validate:@"1111"];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid value considered valid");
}


@end
