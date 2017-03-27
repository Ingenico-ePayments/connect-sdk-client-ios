//
//  ICPaymentProductTestCase.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <IngenicoConnectSDK/ICPaymentProduct.h>

@interface ICPaymentProductTestCase : XCTestCase

@property (strong, nonatomic) ICPaymentProduct *paymentProduct;
@property (strong, nonatomic) ICPaymentProductField *field;

@end

@implementation ICPaymentProductTestCase

- (void)setUp
{
    [super setUp];
    self.paymentProduct = [[ICPaymentProduct alloc] init];
    self.field = [[ICPaymentProductField alloc] init];
    self.field.identifier = @"1";
    [self.paymentProduct.fields.paymentProductFields addObject:self.field];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testPaymentProductFieldWithIdExists
{
    ICPaymentProductField *field = [self.paymentProduct paymentProductFieldWithId:@"1"];
    XCTAssertEqual(field, self.field, @"Retrieved field is unequal to added field");
}

- (void)testPaymentProductFieldWithIdNil
{
    ICPaymentProductField *field = [self.paymentProduct paymentProductFieldWithId:@"X"];
    XCTAssertTrue(field == nil, @"Retrieved a field while no field should be returned");
}

@end
