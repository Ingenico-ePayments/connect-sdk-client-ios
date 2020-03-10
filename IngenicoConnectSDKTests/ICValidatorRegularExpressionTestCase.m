//
//  ICValidatorRegularExpressionTestCase.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ICValidatorRegularExpression.h"

@interface ICValidatorRegularExpressionTestCase : XCTestCase

@property (strong, nonatomic) ICValidatorRegularExpression *validator;

@end

@implementation ICValidatorRegularExpressionTestCase

- (void)setUp
{
    [super setUp];
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"\\d{3}" options:0 error:NULL];
    self.validator = [[ICValidatorRegularExpression alloc] initWithRegularExpression:regularExpression];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testValidateCorrect
{
    [self.validator validate:@"123" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid value considered invalid");
}

- (void)testValidateIncorrect
{
    [self.validator validate:@"abc" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid value considered valid");
}

@end
