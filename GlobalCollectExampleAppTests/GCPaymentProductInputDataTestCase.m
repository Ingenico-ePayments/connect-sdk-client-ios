//
//  GCPaymentProductInputDataTestCase.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 20/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCPaymentProductInputData.h"
#import "GCPaymentProductConverter.h"
#import "GCPaymentRequest.h"

@interface GCPaymentProductInputDataTestCase : XCTestCase

@property (nonatomic, strong) GCPaymentProductInputData *inputData;
@property (nonatomic, strong) GCPaymentProductConverter *converter;

@end

@implementation GCPaymentProductInputDataTestCase

- (void)setUp {
    [super setUp];

    self.inputData = [[GCPaymentProductInputData alloc] init];
    self.converter = [[GCPaymentProductConverter alloc] init];
    NSString *paymentProductPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"paymentProduct" ofType:@"json"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *paymentProductData = [fileManager contentsAtPath:paymentProductPath];
    NSDictionary *paymentProductJSON = [NSJSONSerialization JSONObjectWithData:paymentProductData options:0 error:NULL];
    GCPaymentProduct *paymentProduct = [self.converter paymentProductFromJSON:paymentProductJSON];
    self.inputData.paymentItem = paymentProduct;
    self.inputData.accountOnFile = paymentProduct.accountsOnFile.accountsOnFile[0];
}

- (void)tearDown {

    [super tearDown];
}

- (void)testSetValue
{
    [self.inputData setValue:@"12345678" forField:@"cardNumber"];
    NSString *maskedValue = [self.inputData maskedValueForField:@"cardNumber"];
    NSString *expectedOutput = @"1234 5678 ";
    XCTAssertTrue([maskedValue isEqualToString:expectedOutput] == YES, @"Value not set correctly in payment request");
}

- (void)testValidate
{
    [self.inputData setValue:@"1" forField:@"cvv"];
    [self.inputData validate];
    XCTAssertTrue(self.inputData.errors.count == 2, @"Unexpected number of errors while validating payment request");
}

- (void)testFieldIsPartOfAccountOnFileYes
{
    XCTAssertTrue([self.inputData fieldIsPartOfAccountOnFile:@"cardNumber"] == YES, @"Card number should be part of account on file");
}

- (void)testFieldIsPartOfAccountOnFileNo
{
    XCTAssertTrue([self.inputData fieldIsPartOfAccountOnFile:@"cvv"] == NO, @"CVV should not be part of account on file");
}

- (void)testMaskedValueForField
{
    NSString *maskedValue = [self.inputData maskedValueForField:@"expiryDate"];
    XCTAssertTrue([maskedValue isEqualToString:@"08/20"] == YES, @"Masked expiry date is incorrect");
}

- (void)testMaskedValueForFieldWithCursorPosition
{
    NSInteger cursorPosition = 4;
    NSString *maskedValue = [self.inputData maskedValueForField:@"expiryDate" cursorPosition:&cursorPosition];
    XCTAssertTrue([maskedValue isEqualToString:@"08/20"] == YES, @"Masked expiry date is incorrect");
    XCTAssertTrue(cursorPosition == 5, @"Cursor position after applying mask is incorrect");
}

- (void)testUnmaskedValueForField
{
    NSString *value = [self.inputData unmaskedValueForField:@"expiryDate"];
    XCTAssertTrue([value isEqualToString:@"0820"] == YES, @"Unmasked expiry date is incorrect");
}

@end
