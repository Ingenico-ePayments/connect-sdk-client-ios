//
//  GCPaymentProductFieldTestCase.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 16/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCPaymentProductField.h"
#import "GCValidatorLength.h"
#import "GCValidatorRange.h"

@interface GCPaymentProductFieldTestCase : XCTestCase

@property (strong, nonatomic) GCPaymentProductField *field;

@end

@implementation GCPaymentProductFieldTestCase

- (void)setUp
{
    [super setUp];
    self.field = [[GCPaymentProductField alloc] init];
    GCValidatorLength *length = [[GCValidatorLength alloc] init];
    length.minLength = 4;
    length.maxLength = 6;
    GCValidatorRange *range = [[GCValidatorRange alloc] init];
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
