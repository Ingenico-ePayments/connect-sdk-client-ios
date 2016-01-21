//
//  GCBasicPaymentProductTestCase.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 16/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCBasicPaymentProduct.h"

@interface GCBasicPaymentProductTestCase : XCTestCase

@property (strong, nonatomic) GCBasicPaymentProduct *product;
@property (strong, nonatomic) GCAccountsOnFile *accountsOnFile;
@property (strong, nonatomic) GCAccountOnFile *account1;
@property (strong, nonatomic) GCAccountOnFile *account2;

@end

@implementation GCBasicPaymentProductTestCase

- (void)setUp
{
    [super setUp];
    self.product = [[GCBasicPaymentProduct alloc] init];
    self.accountsOnFile = [[GCAccountsOnFile alloc] init];
    self.account1 = [[GCAccountOnFile alloc] init];
    self.account1.identifier = @"1";
    self.account2 = [[GCAccountOnFile alloc] init];
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
