//
//  GCBasicPaymentProductConverterTestCase.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 16/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCBasicPaymentProductConverter.h"

@interface GCBasicPaymentProductConverterTestCase : XCTestCase

@property (strong, nonatomic) GCBasicPaymentProductConverter *converter;

@end

@implementation GCBasicPaymentProductConverterTestCase

- (void)setUp
{
    [super setUp];
    self.converter = [[GCBasicPaymentProductConverter alloc] init];
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
    GCBasicPaymentProduct *paymentProduct = [self.converter basicPaymentProductFromJSON:paymentProductJSON];
    XCTAssertTrue([paymentProduct.identifier isEqualToString:@"1"] == YES, @"Payment product has an unexpected identifier");
    XCTAssertTrue(paymentProduct.allowsRecurring, @"Unexpected value for 'allowsRecurring'");
    XCTAssertTrue(paymentProduct.allowsTokenization, @"Unexpected value for 'allowsTokenization'");
    XCTAssertNotNil(paymentProduct.displayHints.logoPath, @"Display hints of payment product has no logo path");
    XCTAssertTrue(paymentProduct.accountsOnFile.accountsOnFile.count == 1, @"Unexpected number of accounts on file");
    GCAccountOnFile *accountOnFile = paymentProduct.accountsOnFile.accountsOnFile[0];
    XCTAssertTrue(accountOnFile.attributes.attributes.count == 4, @"Unexpected number of attributes in account on file");
}

@end
