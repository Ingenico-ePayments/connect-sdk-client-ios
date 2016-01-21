//
//  GCValidatorFixedListTestCase.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 16/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCValidatorFixedList.h"

@interface GCValidatorFixedListTestCase : XCTestCase

@property (strong, nonatomic) GCValidatorFixedList *validator;

@end

@implementation GCValidatorFixedListTestCase

- (void)setUp
{
    [super setUp];
    self.validator = [[GCValidatorFixedList alloc] initWithAllowedValues:@[@"1"]];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testValidateCorrect
{
    [self.validator validate:@"1"];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid value considered invalid");
}

- (void)testValidateIncorrect
{
    [self.validator validate:@"X"];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid value considered valid");
}

@end
