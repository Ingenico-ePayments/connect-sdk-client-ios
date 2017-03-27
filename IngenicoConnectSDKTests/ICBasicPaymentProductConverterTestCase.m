//
//  ICBasicPaymentProductConverterTestCase.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <IngenicoConnectSDK/ICBasicPaymentProductConverter.h>

@interface ICBasicPaymentProductConverterTestCase : XCTestCase

@property (strong, nonatomic) ICBasicPaymentProductConverter *converter;

@end

@implementation ICBasicPaymentProductConverterTestCase

- (void)setUp
{
    [super setUp];
    self.converter = [[ICBasicPaymentProductConverter alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testBasicPaymentProductFromJSON
{
    NSString *paymentProductPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"paymentProduct" ofType:@"json"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *paymentProductData = [fileManager contentsAtPath:paymentProductPath];
    NSDictionary *paymentProductJSON = [NSJSONSerialization JSONObjectWithData:paymentProductData options:0 error:NULL];
    ICBasicPaymentProduct *paymentProduct = [self.converter basicPaymentProductFromJSON:paymentProductJSON];
    XCTAssertTrue([paymentProduct.identifier isEqualToString:@"1"] == YES, @"Payment product has an unexpected identifier");
    XCTAssertTrue(paymentProduct.allowsRecurring, @"Unexpected value for 'allowsRecurring'");
    XCTAssertTrue(paymentProduct.allowsTokenization, @"Unexpected value for 'allowsTokenization'");
    XCTAssertNotNil(paymentProduct.displayHints.logoPath, @"Display hints of payment product has no logo path");
    XCTAssertTrue(paymentProduct.accountsOnFile.accountsOnFile.count == 1, @"Unexpected number of accounts on file");
    ICAccountOnFile *accountOnFile = paymentProduct.accountsOnFile.accountsOnFile[0];
    XCTAssertTrue(accountOnFile.attributes.attributes.count == 4, @"Unexpected number of attributes in account on file");
}

@end
