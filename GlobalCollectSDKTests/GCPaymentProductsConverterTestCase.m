//
//  GCPaymentProductsConverterTestCase.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 16/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCPaymentProductsConverter.h"

@interface GCPaymentProductsConverterTestCase : XCTestCase

@property (strong, nonatomic) GCPaymentProductsConverter *converter;

@end

@implementation GCPaymentProductsConverterTestCase

- (void)setUp
{
    [super setUp];
    self.converter = [[GCPaymentProductsConverter alloc] init];
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
    GCPaymentProducts *paymentProducts = [self.converter paymentProductsFromJSON:[paymentProductsJSON objectForKey:@"paymentProducts"]];
    if (paymentProducts.paymentProducts.count != 26) {
        XCTFail(@"Wrong number of payment products.");
    }
    for (GCBasicPaymentProduct *product in paymentProducts.paymentProducts) {
        XCTAssertNotNil(product.identifier, @"Payment product has no identifier");
        XCTAssertFalse(product.autoTokenized, @"Product's autoTokenized property is not false");
        XCTAssertNotNil(product.displayHints, @"Payment product has no displayHints");
        XCTAssertNotNil(product.displayHints.logoPath, @"Payment product has no logo path in displayHints");
        if (product.accountsOnFile != nil) {
            for (GCAccountOnFile *accountOnFile in product.accountsOnFile.accountsOnFile) {
                XCTAssertNotNil(accountOnFile.attributes, @"Account on file has no attributes");
                XCTAssertNotNil(accountOnFile.displayHints, @"Account on file has no displayHints");
            }
        }
    }
}

@end
