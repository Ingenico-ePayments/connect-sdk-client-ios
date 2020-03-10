//
//  ICPaymentProductsConverterTestCase.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import  "ICBasicPaymentProductsConverter.h"

@interface ICPaymentProductsConverterTestCase : XCTestCase

@property (strong, nonatomic) ICBasicPaymentProductsConverter *converter;

@end

@implementation ICPaymentProductsConverterTestCase

- (void)setUp
{
    [super setUp];
    self.converter = [[ICBasicPaymentProductsConverter alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testPaymentProductsFromJSON
{
    NSString *paymentProductsPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"paymentProducts" ofType:@"json"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *paymentProductsData = [fileManager contentsAtPath:paymentProductsPath];
    NSDictionary *paymentProductsJSON = [NSJSONSerialization JSONObjectWithData:paymentProductsData options:0 error:NULL];
    ICBasicPaymentProducts *paymentProducts = [self.converter paymentProductsFromJSON:[paymentProductsJSON objectForKey:@"paymentProducts"]];
    if (paymentProducts.paymentProducts.count != 24) {
        XCTFail(@"Wrong number of payment products.");
    }
    for (ICBasicPaymentProduct *product in paymentProducts.paymentProducts) {
        XCTAssertNotNil(product.identifier, @"Payment product has no identifier");
        XCTAssertFalse(product.autoTokenized, @"Product's autoTokenized property is not false");
        XCTAssertNotNil(product.displayHints, @"Payment product has no displayHints");
        XCTAssertNotNil(product.displayHints.logoPath, @"Payment product has no logo path in displayHints");
        if (product.accountsOnFile != nil) {
            for (ICAccountOnFile *accountOnFile in product.accountsOnFile.accountsOnFile) {
                XCTAssertNotNil(accountOnFile.attributes, @"Account on file has no attributes");
                XCTAssertNotNil(accountOnFile.displayHints, @"Account on file has no displayHints");
            }
        }
    }
}

@end
