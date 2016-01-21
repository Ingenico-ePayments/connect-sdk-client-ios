//
//  GCValidatorRegularExpressionTestCase.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 16/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCValidatorRegularExpression.h"

@interface GCValidatorRegularExpressionTestCase : XCTestCase

@property (strong, nonatomic) GCValidatorRegularExpression *validator;

@end

@implementation GCValidatorRegularExpressionTestCase

- (void)setUp
{
    [super setUp];
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"\\d{3}" options:0 error:NULL];
    self.validator = [[GCValidatorRegularExpression alloc] initWithRegularExpression:regularExpression];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testValidateCorrect
{
    [self.validator validate:@"123"];
    XCTAssertTrue(self.validator.errors.count == 0, @"Valid value considered invalid");
}

- (void)testValidateIncorrect
{
    [self.validator validate:@"abc"];
    XCTAssertTrue(self.validator.errors.count != 0, @"Invalid value considered valid");
}

@end
