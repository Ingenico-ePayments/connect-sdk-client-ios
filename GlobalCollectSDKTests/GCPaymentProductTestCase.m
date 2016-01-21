//
//  GCPaymentProductTestCase.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 16/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCPaymentProduct.h"

@interface GCPaymentProductTestCase : XCTestCase

@property (strong, nonatomic) GCPaymentProduct *paymentProduct;
@property (strong, nonatomic) GCPaymentProductField *field;

@end

@implementation GCPaymentProductTestCase

- (void)setUp
{
    [super setUp];
    self.paymentProduct = [[GCPaymentProduct alloc] init];
    self.field = [[GCPaymentProductField alloc] init];
    self.field.identifier = @"1";
    [self.paymentProduct.fields.paymentProductFields addObject:self.field];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testPaymentProductFieldWithIdExists
{
    GCPaymentProductField *field = [self.paymentProduct paymentProductFieldWithId:@"1"];
    XCTAssertEqual(field, self.field, @"Retrieved field is unequal to added field");
}

- (void)testPaymentProductFieldWithIdNil
{
    GCPaymentProductField *field = [self.paymentProduct paymentProductFieldWithId:@"X"];
    XCTAssertTrue(field == nil, @"Retrieved a field while no field should be returned");
}

@end
