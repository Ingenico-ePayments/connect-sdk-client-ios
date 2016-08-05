//
//  GCPaymentRequestTestCase.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 16/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCPaymentRequest.h"
#import "GCPaymentProductConverter.h"

@interface GCPaymentRequestTestCase : XCTestCase

@property (strong, nonatomic) GCPaymentRequest *request;
@property (strong, nonatomic) GCPaymentProductConverter *converter;
@end

@implementation GCPaymentRequestTestCase

- (void)setUp
{
    [super setUp];
    self.request = [[GCPaymentRequest alloc] init];
    self.converter = [[GCPaymentProductConverter alloc] init];
    NSString *paymentProductPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"paymentProduct" ofType:@"json"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *paymentProductData = [fileManager contentsAtPath:paymentProductPath];
    NSDictionary *paymentProductJSON = [NSJSONSerialization JSONObjectWithData:paymentProductData options:0 error:NULL];
    GCPaymentProduct *paymentProduct = [self.converter paymentProductFromJSON:paymentProductJSON];
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
