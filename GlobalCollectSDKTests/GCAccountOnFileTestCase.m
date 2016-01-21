//
//  GCAccountOnFileTestCase.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 16/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCAccountOnFile.h"
#import "GCPaymentProductConverter.h"

@interface GCAccountOnFileTestCase : XCTestCase

@property (strong, nonatomic) GCAccountOnFile *accountOnFile;
@property (strong, nonatomic) GCPaymentProductConverter *converter;
@property (strong, nonatomic) GCStringFormatter *stringFormatter;

@end

@implementation GCAccountOnFileTestCase

- (void)setUp
{
    [super setUp];
    self.accountOnFile = [[GCAccountOnFile alloc] init];
    self.converter = [[GCPaymentProductConverter alloc] init];
    NSString *paymentProductPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"paymentProduct" ofType:@"json"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *paymentProductData = [fileManager contentsAtPath:paymentProductPath];
    NSDictionary *paymentProductJSON = [NSJSONSerialization JSONObjectWithData:paymentProductData options:0 error:NULL];
    GCPaymentProduct *paymentProduct = [self.converter paymentProductFromJSON:paymentProductJSON];
    self.accountOnFile = paymentProduct.accountsOnFile.accountsOnFile[0];
    self.stringFormatter = [[GCStringFormatter alloc] init];
    self.accountOnFile.stringFormatter = self.stringFormatter;
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testMaskedValueForField
{
    NSString *value = [self.accountOnFile maskedValueForField:@"cardNumber"];
    XCTAssertTrue([value isEqualToString:@"**** **** **** 7988 "] == YES, @"Card number of account on file is incorrect");
}

- (void)testMaskedValueForFieldWithMask
{
    NSString *value = [self.accountOnFile maskedValueForField:@"expiryDate" mask:@"{{99}}   {{99}}"];
    XCTAssertTrue([value isEqualToString:@"08   20"] == YES, @"Expiry date of account on file is incorrect");
}

- (void)testHasValueForFieldYes
{
    XCTAssertTrue([self.accountOnFile hasValueForField:@"expiryDate"] == YES, @"Account on file has no value for expiry date");
}

- (void)testHasValueForFieldNo
{
    XCTAssertTrue([self.accountOnFile hasValueForField:@"cvv"] == NO, @"Account on file has a value for cvv");
}

- (void)testLabel
{
    NSString *actualLabel = [self.accountOnFile label];
    NSString *expectedLabel = @"**** **** **** 7988 Rob";
    XCTAssertTrue([actualLabel isEqualToString:expectedLabel] == YES);
}

@end
