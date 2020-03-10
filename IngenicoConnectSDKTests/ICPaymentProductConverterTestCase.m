//
//  ICPaymentProductConverterTestCase.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import  "ICPaymentProductConverter.h"
#import  "ICValidator.h"
#import  "ICValidatorLength.h"
#import  "ICAccountOnFileAttribute.h"

@interface ICPaymentProductConverterTestCase : XCTestCase

@property (strong, nonatomic) ICPaymentProductConverter *converter;
@end

@implementation ICPaymentProductConverterTestCase

- (void)setUp
{
    [super setUp];
    self.converter = [[ICPaymentProductConverter alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testPaymentProductFromJSON
{
    NSString *paymentProductPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"paymentProduct" ofType:@"json"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *paymentProductData = [fileManager contentsAtPath:paymentProductPath];
    NSDictionary *paymentProductJSON = [NSJSONSerialization JSONObjectWithData:paymentProductData options:0 error:NULL];
    ICPaymentProduct *paymentProduct = [self.converter paymentProductFromJSON:paymentProductJSON];
    XCTAssertTrue(paymentProduct.fields.paymentProductFields.count == 3, @"Unexpected number of fields");
    ICPaymentProductField *field = paymentProduct.fields.paymentProductFields[0];
    XCTAssertTrue(field.dataRestrictions.isRequired == true, @"Unexpected value for 'isRequired'");
    XCTAssertTrue(field.displayHints.alwaysShow, @"Unexpected value for 'alwaysShow'");
    XCTAssertTrue(field.displayHints.displayOrder == 10, @"Unexpected value for 'displayOrder'");
    XCTAssertTrue(field.displayHints.obfuscate == false, @"Unexpected value for 'obfuscate'");
    XCTAssertTrue([field.identifier isEqualToString:@"cardNumber"] == YES, @"Unexpected identifier");
    XCTAssertTrue(field.dataRestrictions.validators.validators.count == 2, @"Unexpected number of validators");
    ICValidatorLength *validator = field.dataRestrictions.validators.validators[1];
    XCTAssertTrue(validator.maxLength == 19, @"Unexpected maximal length");
    ICAccountOnFile *accountOnFile = paymentProduct.accountsOnFile.accountsOnFile[0];
    XCTAssertTrue(accountOnFile.attributes.attributes.count == 4, @"Unexpected number of attributes of account on file");
    ICAccountOnFileAttribute *attribute = accountOnFile.attributes.attributes[0];
    XCTAssertTrue([attribute.key isEqualToString:@"cardholderName"], @"Unexpected key");
    XCTAssertTrue([attribute.value isEqualToString:@"Rob"], @"Unexpected value");
    XCTAssertTrue(attribute.status == ICMustWrite, @"Unexpected status");
    XCTAssertTrue([attribute.mustWriteReason isEqualToString:@"IN_THE_PAST"], @"Unexpected must-write reason");
    attribute = accountOnFile.attributes.attributes[1];
    XCTAssertTrue(attribute.mustWriteReason == nil, @"Must-write reason is not nil");
}

- (void)testPaymentProductWithMissingFieldsFromJSON
{
    NSString *paymentProductPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"paymentProductMissingFields" ofType:@"json"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *paymentProductData = [fileManager contentsAtPath:paymentProductPath];
    NSDictionary *paymentProductJSON = [NSJSONSerialization JSONObjectWithData:paymentProductData options:0 error:NULL];
    ICPaymentProduct *paymentProduct = [self.converter paymentProductFromJSON:paymentProductJSON];
    XCTAssertTrue(paymentProduct.fields.paymentProductFields.count == 3, @"Unexpected number of fields");
    ICPaymentProductField *field = paymentProduct.fields.paymentProductFields[0];
    NSLog(@"Field: %@", field);
    XCTAssertTrue(field.dataRestrictions.isRequired == true, @"Unexpected value for 'isRequired'");
    XCTAssertTrue(field.displayHints.displayOrder == 10, @"Unexpected value for 'displayOrder'");
    XCTAssertTrue(field.displayHints.obfuscate == false, @"Unexpected value for 'obfuscate'");
    XCTAssertTrue([field.identifier isEqualToString:@"cardNumber"] == YES, @"Unexpected identifier");
    XCTAssertTrue(field.dataRestrictions.validators.validators.count == 2, @"Unexpected number of validators");
    ICValidatorLength *validator = field.dataRestrictions.validators.validators[1];
    XCTAssertTrue(validator.maxLength == 19, @"Unexpected maximal length");
}

@end
