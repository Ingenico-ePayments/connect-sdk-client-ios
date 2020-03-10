//
//  ICAccountsOnFileTestCase.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import  "ICAccountsOnFile.h"
#import  "ICAccountOnFile.h"

@interface ICAccountsOnFileTestCase : XCTestCase

@property (strong, nonatomic) ICAccountsOnFile *accountsOnFile;
@property (strong, nonatomic) ICAccountOnFile *account1;
@property (strong, nonatomic) ICAccountOnFile *account2;

@end

@implementation ICAccountsOnFileTestCase

- (void)setUp
{
    [super setUp];
    self.accountsOnFile = [[ICAccountsOnFile alloc] init];
    self.account1 = [[ICAccountOnFile alloc] init];
    self.account1.identifier = @"1";
    self.account2 = [[ICAccountOnFile alloc] init];
    self.account2.identifier = @"2";
    [self.accountsOnFile.accountsOnFile addObject:self.account1];
    [self.accountsOnFile.accountsOnFile addObject:self.account2];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testAccountOnFileWithIdentifier
{
    XCTAssertEqual([self.accountsOnFile accountOnFileWithIdentifier:@"1"], self.account1, @"Incorrect account on file retrieved");
}

@end
