//
//  ICValidatorEmailAddressTestCase.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import  "ICValidatorEmailAddress.h"

@interface ICValidatorEmailAddressTestCase : XCTestCase

@property (strong, nonatomic) ICValidatorEmailAddress *validator;

@end

@implementation ICValidatorEmailAddressTestCase

- (void)setUp
{
    [super setUp];
    self.validator = [[ICValidatorEmailAddress alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testValidateCorrect1
{
    [self.validator validate:@"test@example.com" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid address is considered invalid");
}

- (void)testValidateCorrect3
{
    [self.validator validate:@"\"Fred Bloggs\"@example.com" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid address is considered invalid");
}

- (void)testValidateCorrect4
{
    [self.validator validate:@"\"Joe\\Blow\"@example.com" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid address is considered invalid");
}

- (void)testValidateCorrect6
{
    [self.validator validate:@"customer/department=shipping@example.com" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid address is considered invalid");
}

- (void)testValidateCorrect7
{
    [self.validator validate:@"$A12345@example.com" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid address is considered invalid");
}

- (void)testValidateCorrect8
{
    [self.validator validate:@"!def!xyz%abc@example.com" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid address is considered invalid");
}

- (void)testValidateCorrect9
{
    [self.validator validate:@"_somename@example.com" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid address is considered invalid");
}

- (void)testValidateCorrect10
{
    [self.validator validate:@"\"b(c)d,e:f;g<h>i[j\\k]l@example.com"];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid address is considered invalid");
}

- (void)testValidateCorrect11
{
    [self.validator validate:@"just\"not\"right@example.com" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid address is considered invalid");
}

- (void)testValidateCorrect12
{
    [self.validator validate:@"this is\"not\allowed@example.com" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid address is considered invalid");
}

- (void)testValidateCorrect13
{
    [self.validator validate:@"this\\ still\"not\\allowed@example.com" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid address is considered invalid");
}

- (void)testValidateIncorrect1
{
    [self.validator validate:@"Abc.example.com" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid address is considered valid");
}

- (void)testValidateIncorrect2
{
    [self.validator validate:@"A@b@c@example.com" forPaymentRequest:nil];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid address is considered valid");
}

- (void)testValidateInCorrect7
{
   [self.validator validate:@"\"Abc\\@def\"@example.com"];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid address is considered valid");
}

- (void)testValidateInCorrect8
{
    [self.validator validate:@"\"Abc@def\"@example.com"];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid address is considered valid");
}


@end
