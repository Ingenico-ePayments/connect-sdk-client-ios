//
//  ICPaymentProductFieldTestCase.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import  "ICPaymentProductField.h"
#import  "ICValidatorLength.h"
#import  "ICValidatorRange.h"

@interface ICPaymentProductFieldTestCase : XCTestCase

@property (strong, nonatomic) ICPaymentProductField *field;

@end

@implementation ICPaymentProductFieldTestCase

- (void)setUp
{
    [super setUp];
    self.field = [[ICPaymentProductField alloc] init];
    ICValidatorLength *length = [[ICValidatorLength alloc] init];
    length.minLength = 4;
    length.maxLength = 6;
    ICValidatorRange *range = [[ICValidatorRange alloc] init];
    range.minValue = 50;
    range.maxValue = 60;
    [self.field.dataRestrictions.validators.validators addObject:length];
    [self.field.dataRestrictions.validators.validators addObject:range];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testValidateValueCorrect
{
    [self.field validateValue:@"0055"];
    XCTAssertTrue(self.field.errors.count == 0, @"Unexpected errors after validation");
}

- (void)testValidateValueIncorrect
{
    [self.field validateValue:@"0"];
    XCTAssertTrue(self.field.errors.count == 2, @"Unexpected number of errors after validation");
}

@end
