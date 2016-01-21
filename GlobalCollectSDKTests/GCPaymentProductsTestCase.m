//
//  GCPaymentProductsTestCase.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 16/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCPaymentProducts.h"

@interface GCPaymentProductsTestCase : XCTestCase

@property (strong, nonatomic) GCPaymentProducts *products;

@end

@implementation GCPaymentProductsTestCase

- (void)setUp
{
    [super setUp];
    self.products = [[GCPaymentProducts alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testHasAccountsOnFileTrue
{
    GCAccountOnFile *account = [[GCAccountOnFile alloc] init];
    GCBasicPaymentProduct *product = [[GCBasicPaymentProduct alloc] init];
    [product.accountsOnFile.accountsOnFile addObject:account];
    [self.products.paymentProducts addObject:product];
    XCTAssertTrue([self.products hasAccountsOnFile] == YES, @"Payment products should have an account on file");
}

- (void)testHasAccountsOnFileFalse
{
    XCTAssertTrue([self.products hasAccountsOnFile] == NO, @"Payment products should not have an account on file");
}

- (void)testAccountsOnFile
{
    GCAccountOnFile *account = [[GCAccountOnFile alloc] init];
    GCBasicPaymentProduct *product = [[GCBasicPaymentProduct alloc] init];
    [product.accountsOnFile.accountsOnFile addObject:account];
    [self.products.paymentProducts addObject:product];
    NSArray *accountsOnFile = self.products.accountsOnFile;
    XCTAssertTrue(accountsOnFile.count == 1, @"Unexpected number of accounts on file");
    XCTAssertTrue(accountsOnFile[0] == account, @"Account on file that was added is not returned");
}

- (void)testPaymentProductWithIdentifierExisting
{
    GCBasicPaymentProduct *product = [[GCBasicPaymentProduct alloc] init];
    product.identifier = @"1";
    [self.products.paymentProducts addObject:product];
    XCTAssertTrue([self.products paymentProductWithIdentifier:@"1"] == product, @"Unexpected payment product retrieved");
}

- (void)testPaymentProductWithIdentifierNonExisting
{
    GCBasicPaymentProduct *product = [[GCBasicPaymentProduct alloc] init];
    product.identifier = @"1";
    [self.products.paymentProducts addObject:product];
    XCTAssertTrue([self.products paymentProductWithIdentifier:@"X"] == nil, @"Retrieved a payment product that has not been added");
}

- (void)testSort
{
    GCBasicPaymentProduct *product1 = [[GCBasicPaymentProduct alloc] init];
    product1.displayHints.displayOrder = 100;
    [self.products.paymentProducts addObject:product1];
    GCBasicPaymentProduct *product2 = [[GCBasicPaymentProduct alloc] init];
    product2.displayHints.displayOrder = 10;
    [self.products.paymentProducts addObject:product2];
    GCBasicPaymentProduct *product3 = [[GCBasicPaymentProduct alloc] init];
    product3.displayHints.displayOrder = 99;
    [self.products.paymentProducts addObject:product3];
    [self.products sort];
    NSUInteger displayOrder = 0;
    for (int i = 0; i < 3; ++i) {
        GCBasicPaymentProduct *product = self.products.paymentProducts[i];
        if (displayOrder > product.displayHints.displayOrder) {
            XCTFail(@"Products are not sorted");
        }
        displayOrder = product.displayHints.displayOrder;
    }
}

@end
