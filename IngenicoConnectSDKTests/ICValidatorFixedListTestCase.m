//
//  ICValidatorFixedListTestCase.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import  "ICValidatorFixedList.h"

@interface ICValidatorFixedListTestCase : XCTestCase

@property (strong, nonatomic) ICValidatorFixedList *validator;

@end

@implementation ICValidatorFixedListTestCase

- (void)setUp
{
    [super setUp];
    self.validator = [[ICValidatorFixedList alloc] initWithAllowedValues:@[@"1"]];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testValidateCorrect
{
    [self.validator validate:@"1" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid value considered invalid");
}

- (void)testValidateIncorrect
{
    [self.validator validate:@"X" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid value considered valid");
}

@end
