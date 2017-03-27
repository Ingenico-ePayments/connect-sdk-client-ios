//
//  ICPaymentProductFieldsTestCase.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <IngenicoConnectSDK/ICPaymentPRoductFields.h>
#import <IngenicoConnectSDK/ICPaymentProductField.h>

@interface ICPaymentProductFieldsTestCase : XCTestCase

@property (strong, nonatomic) ICPaymentProductFields *fields;

@end

@implementation ICPaymentProductFieldsTestCase

- (void)setUp
{
    [super setUp];
    self.fields = [[ICPaymentProductFields alloc] init];
    ICPaymentProductField *field1 = [[ICPaymentProductField alloc] init];
    field1.displayHints.displayOrder = 1;
    ICPaymentProductField *field2 = [[ICPaymentProductField alloc] init];
    field2.displayHints.displayOrder = 100;
    ICPaymentProductField *field3 = [[ICPaymentProductField alloc] init];
    field3.displayHints.displayOrder = 4;
    ICPaymentProductField *field4 = [[ICPaymentProductField alloc] init];
    field4.displayHints.displayOrder = 50;
    ICPaymentProductField *field5 = [[ICPaymentProductField alloc] init];
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
    for (ICPaymentProductField *field in self.fields.paymentProductFields) {
        if (displayOrder > field.displayHints.displayOrder) {
            XCTFail(@"Fields not sorted according to display order");
        }
        displayOrder = field.displayHints.displayOrder;
    }
}

@end
