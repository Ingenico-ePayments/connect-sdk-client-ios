//
//  ICBasicPaymentProductTestCase.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <IngenicoConnectSDK/ICBasicPaymentProduct.h>

@interface ICBasicPaymentProductTestCase : XCTestCase

@property (strong, nonatomic) ICBasicPaymentProduct *product;
@property (strong, nonatomic) ICAccountsOnFile *accountsOnFile;
@property (strong, nonatomic) ICAccountOnFile *account1;
@property (strong, nonatomic) ICAccountOnFile *account2;

@end

@implementation ICBasicPaymentProductTestCase

- (void)setUp
{
    [super setUp];
    self.product = [[ICBasicPaymentProduct alloc] init];
    self.accountsOnFile = [[ICAccountsOnFile alloc] init];
    self.account1 = [[ICAccountOnFile alloc] init];
    self.account1.identifier = @"1";
    self.account2 = [[ICAccountOnFile alloc] init];
    self.account2.identifier = @"2";
    [self.accountsOnFile.accountsOnFile addObject:self.account1];
    [self.accountsOnFile.accountsOnFile addObject:self.account2];
    self.product.accountsOnFile = self.accountsOnFile;
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testAccountOnFileWithIdentifier
{
    XCTAssertEqual([self.product accountOnFileWithIdentifier:@"1"], self.account1, @"Unexpected account on file retrieved");
}

@end
