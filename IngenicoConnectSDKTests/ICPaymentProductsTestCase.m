//
//  ICPaymentProductsTestCase.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import  "ICBasicPaymentProducts.h"

@interface ICPaymentProductsTestCase : XCTestCase

@property (strong, nonatomic) ICBasicPaymentProducts *products;

@end

@implementation ICPaymentProductsTestCase

- (void)setUp
{
    [super setUp];
    self.products = [[ICBasicPaymentProducts alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testHasAccountsOnFileTrue
{
    ICAccountOnFile *account = [[ICAccountOnFile alloc] init];
    ICBasicPaymentProduct *product = [[ICBasicPaymentProduct alloc] init];
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
    ICAccountOnFile *account = [[ICAccountOnFile alloc] init];
    ICBasicPaymentProduct *product = [[ICBasicPaymentProduct alloc] init];
    [product.accountsOnFile.accountsOnFile addObject:account];
    [self.products.paymentProducts addObject:product];
    NSArray *accountsOnFile = self.products.accountsOnFile;
    XCTAssertTrue(accountsOnFile.count == 1, @"Unexpected number of accounts on file");
    XCTAssertTrue(accountsOnFile[0] == account, @"Account on file that was added is not returned");
}

- (void)testPaymentProductWithIdentifierExisting
{
    ICBasicPaymentProduct *product = [[ICBasicPaymentProduct alloc] init];
    product.identifier = @"1";
    [self.products.paymentProducts addObject:product];
    XCTAssertTrue([self.products paymentProductWithIdentifier:@"1"] == product, @"Unexpected payment product retrieved");
}

- (void)testPaymentProductWithIdentifierNonExisting
{
    ICBasicPaymentProduct *product = [[ICBasicPaymentProduct alloc] init];
    product.identifier = @"1";
    [self.products.paymentProducts addObject:product];
    XCTAssertTrue([self.products paymentProductWithIdentifier:@"X"] == nil, @"Retrieved a payment product that has not been added");
}

- (void)testSort
{
    ICBasicPaymentProduct *product1 = [[ICBasicPaymentProduct alloc] init];
    product1.displayHints.displayOrder = 100;
    [self.products.paymentProducts addObject:product1];
    ICBasicPaymentProduct *product2 = [[ICBasicPaymentProduct alloc] init];
    product2.displayHints.displayOrder = 10;
    [self.products.paymentProducts addObject:product2];
    ICBasicPaymentProduct *product3 = [[ICBasicPaymentProduct alloc] init];
    product3.displayHints.displayOrder = 99;
    [self.products.paymentProducts addObject:product3];
    [self.products sort];
    NSUInteger displayOrder = 0;
    for (int i = 0; i < 3; ++i) {
        ICBasicPaymentProduct *product = self.products.paymentProducts[i];
        if (displayOrder > product.displayHints.displayOrder) {
            XCTFail(@"Products are not sorted");
        }
        displayOrder = product.displayHints.displayOrder;
    }
}

@end
