//
//  GCValidatorEmailAddressTestCase.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 16/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCValidatorEmailAddress.h"

@interface GCValidatorEmailAddressTestCase : XCTestCase

@property (strong, nonatomic) GCValidatorEmailAddress *validator;

@end

@implementation GCValidatorEmailAddressTestCase

- (void)setUp
{
    [super setUp];
    self.validator = [[GCValidatorEmailAddress alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testValidateCorrect1
{
    [self.validator validate:@"test@example.com"];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid address is considered invalid");
}

// The following examples of valid e-mail addresses are taken from Haacked.com
// (http://haacked.com/archive/2007/08/21/i-knew-how-to-validate-an-email-address-until-i.aspx/)

- (void)testValidateCorrect2
{
   [self.validator validate:@"\"Abc\\@def\"@example.com"];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid address is considered invalid");
}

- (void)testValidateCorrect3
{
    [self.validator validate:@"\"Fred Bloggs\"@example.com"];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid address is considered invalid");
}

- (void)testValidateCorrect4
{
    [self.validator validate:@"\"Joe\\Blow\"@example.com"];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid address is considered invalid");
}

- (void)testValidateCorrect5
{
    [self.validator validate:@"\"Abc@def\"@example.com"];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid address is considered invalid");
}

- (void)testValidateCorrect6
{
    [self.validator validate:@"customer/department=shipping@example.com"];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid address is considered invalid");
}

- (void)testValidateCorrect7
{
    [self.validator validate:@"$A12345@example.com"];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid address is considered invalid");
}

- (void)testValidateCorrect8
{
    [self.validator validate:@"!def!xyz%abc@example.com"];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid address is considered invalid");
}

- (void)testValidateCorrect9
{
    [self.validator validate:@"_somename@example.com"];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid address is considered invalid");
}

// The following examples of invalid e-mail addresses are taken from Wikipedia
// (http://en.wikipedia.org/wiki/Email_address)

- (void)testValidateIncorrect1
{
    [self.validator validate:@"Abc.example.com"];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid address is considered valid");
}

- (void)testValidateIncorrect2
{
    [self.validator validate:@"A@b@c@example.com"];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid address is considered valid");
}

- (void)testValidateIncorrect3
{
    [self.validator validate:@"\"b(c)d,e:f;g<h>i[j\\k]l@example.com"];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid address is considered valid");
}

- (void)testValidateIncorrect4
{
    [self.validator validate:@"just\"not\"right@example.com"];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid address is considered valid");
}

- (void)testValidateIncorrect5
{
    [self.validator validate:@"this is\"not\allowed@example.com"];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid address is considered valid");
}

- (void)testValidateIncorrect6
{
    [self.validator validate:@"this\\ still\"not\\allowed@example.com"];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid address is considered valid");
}


@end
