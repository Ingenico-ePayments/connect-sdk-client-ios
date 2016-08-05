//
//  GCTableSectionConverterTestCase.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 21/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCBasicPaymentProducts.h"
#import "GCBasicPaymentProductsConverter.h"
#import "GCPaymentProductsTableSection.h"
#import "GCPaymentProductsTableRow.h"
#import "GCTableSectionConverter.h"
#import "GCStringFormatter.h"
#import "GCAccountOnFile.h"

@interface GCTableSectionConverterTestCase : XCTestCase

@property (strong, nonatomic) GCBasicPaymentProductsConverter *paymentProductsConverter;
@property (strong, nonatomic) GCStringFormatter *stringFormatter;

@end

@implementation GCTableSectionConverterTestCase

- (void)setUp
{
    [super setUp];
    self.paymentProductsConverter = [[GCBasicPaymentProductsConverter alloc] init];
    self.stringFormatter = [[GCStringFormatter alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testPaymentProductsTableSectionFromAccountsOnFile
{
    NSString *paymentProductsPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"paymentProducts" ofType:@"json"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *paymentProductsData = [fileManager contentsAtPath:paymentProductsPath];
    NSDictionary *paymentProductsJSON = [NSJSONSerialization JSONObjectWithData:paymentProductsData options:0 error:NULL];
    GCBasicPaymentProducts *paymentProducts = [self.paymentProductsConverter paymentProductsFromJSON:[paymentProductsJSON objectForKey:@"paymentProducts"]];
    NSArray *accountsOnFile = [paymentProducts accountsOnFile];
    for (GCAccountOnFile *accountOnFile in accountsOnFile) {
        accountOnFile.stringFormatter = self.stringFormatter;
    }
    GCPaymentProductsTableSection *tableSection = [GCTableSectionConverter paymentProductsTableSectionFromAccountsOnFile:accountsOnFile paymentProducts:paymentProducts];
    GCPaymentProductsTableRow *row = tableSection.rows[0];
    XCTAssertTrue([row.name isEqualToString:@"**** **** **** 7988 Rob"] == YES, @"Unexpected title of table section");
}

@end
