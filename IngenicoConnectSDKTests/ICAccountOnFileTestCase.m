//
//  ICAccountOnFileTestCase.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <IngenicoConnectSDK/ICAccountOnFile.h>
#import <IngenicoConnectSDK/ICPaymentProductConverter.h>

@interface ICAccountOnFileTestCase : XCTestCase

@property (strong, nonatomic) ICAccountOnFile *accountOnFile;
@property (strong, nonatomic) ICPaymentProductConverter *converter;
@property (strong, nonatomic) ICStringFormatter *stringFormatter;

@end

@implementation ICAccountOnFileTestCase

- (void)setUp
{
    [super setUp];
    self.accountOnFile = [[ICAccountOnFile alloc] init];
    self.converter = [[ICPaymentProductConverter alloc] init];
    NSString *paymentProductPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"paymentProduct" ofType:@"json"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *paymentProductData = [fileManager contentsAtPath:paymentProductPath];
    NSDictionary *paymentProductJSON = [NSJSONSerialization JSONObjectWithData:paymentProductData options:0 error:NULL];
    ICPaymentProduct *paymentProduct = [self.converter paymentProductFromJSON:paymentProductJSON];
    self.accountOnFile = paymentProduct.accountsOnFile.accountsOnFile[0];
    self.stringFormatter = [[ICStringFormatter alloc] init];
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
