//
//  ICPaymentRequestTestCase.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <IngenicoConnectSDK/ICPaymentRequest.h>
#import <IngenicoConnectSDK/ICPaymentProductConverter.h>

@interface ICPaymentRequestTestCase : XCTestCase

@property (strong, nonatomic) ICPaymentRequest *request;
@property (strong, nonatomic) ICPaymentProductConverter *converter;
@end

@implementation ICPaymentRequestTestCase

- (void)setUp
{
    [super setUp];
    self.request = [[ICPaymentRequest alloc] init];
    self.converter = [[ICPaymentProductConverter alloc] init];
    NSString *paymentProductPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"paymentProduct" ofType:@"json"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *paymentProductData = [fileManager contentsAtPath:paymentProductPath];
    NSDictionary *paymentProductJSON = [NSJSONSerialization JSONObjectWithData:paymentProductData options:0 error:NULL];
    ICPaymentProduct *paymentProduct = [self.converter paymentProductFromJSON:paymentProductJSON];
    self.request.paymentProduct = paymentProduct;
    self.request.accountOnFile = paymentProduct.accountsOnFile.accountsOnFile[0];
    
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testValidate
{
    [self.request setValue:@"1" forField:@"cvv"];
    [self.request validate];
    XCTAssertTrue(self.request.errors.count == 2, @"Unexpected number of errors while validating payment request");
}

- (void)testUnmaskedFieldValues
{
    [self.request setValue:@"123" forField:@"cvv"];
    NSDictionary *values = [self.request unmaskedFieldValues];
    NSString *cvv = [values valueForKey:@"cvv"];
    XCTAssertTrue([cvv isEqualToString:@"123"] == YES, @"CVV code is incorrect");
}

@end
