//
//  GCAccountsOnFileTestCase.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 16/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCAccountsOnFile.h"
#import "GCAccountOnFile.h"

@interface GCAccountsOnFileTestCase : XCTestCase

@property (strong, nonatomic) GCAccountsOnFile *accountsOnFile;
@property (strong, nonatomic) GCAccountOnFile *account1;
@property (strong, nonatomic) GCAccountOnFile *account2;

@end

@implementation GCAccountsOnFileTestCase

- (void)setUp
{
    [super setUp];
    self.accountsOnFile = [[GCAccountsOnFile alloc] init];
    self.account1 = [[GCAccountOnFile alloc] init];
    self.account1.identifier = @"1";
    self.account2 = [[GCAccountOnFile alloc] init];
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
