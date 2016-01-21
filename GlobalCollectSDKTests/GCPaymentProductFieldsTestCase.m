//
//  GCPaymentProductFieldsTestCase.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 16/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCPaymentPRoductFields.h"
#import "GCPaymentProductField.h"

@interface GCPaymentProductFieldsTestCase : XCTestCase

@property (strong, nonatomic) GCPaymentProductFields *fields;

@end

@implementation GCPaymentProductFieldsTestCase

- (void)setUp
{
    [super setUp];
    self.fields = [[GCPaymentProductFields alloc] init];
    GCPaymentProductField *field1 = [[GCPaymentProductField alloc] init];
    field1.displayHints.displayOrder = 1;
    GCPaymentProductField *field2 = [[GCPaymentProductField alloc] init];
    field2.displayHints.displayOrder = 100;
    GCPaymentProductField *field3 = [[GCPaymentProductField alloc] init];
    field3.displayHints.displayOrder = 4;
    GCPaymentProductField *field4 = [[GCPaymentProductField alloc] init];
    field4.displayHints.displayOrder = 50;
    GCPaymentProductField *field5 = [[GCPaymentProductField alloc] init];
    field5.displayHints.displayOrder = 3;
    [self.fields.paymentProductFields addObject:field1];
    [self.fields.paymentProductFields addObject:field2];
    [self.fields.paymentProductFields addObject:field3];
    [self.fields.paymentProductFields addObject:field4];
    [self.fields.paymentProductFields addObject:field5];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testSort
{
    [self.fields sort];
    NSInteger displayOrder = -1;
    for (GCPaymentProductField *field in self.fields.paymentProductFields) {
        if (displayOrder > field.displayHints.displayOrder) {
            XCTFail(@"Fields not sorted according to display order");
        }
        displayOrder = field.displayHints.displayOrder;
    }
}

@end
