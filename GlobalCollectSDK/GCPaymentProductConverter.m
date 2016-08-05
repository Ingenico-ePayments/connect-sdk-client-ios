//
//  GCPaymentProductConverter.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 03/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCPaymentProductConverter.h"

@implementation GCPaymentProductConverter

- (GCPaymentProduct *)paymentProductFromJSON:(NSDictionary *)rawProduct
{
    GCPaymentProduct *product = [[GCPaymentProduct alloc] init];
    [super setBasicPaymentProduct:product JSON:rawProduct];

    GCPaymentItemConverter *itemConverter = [GCPaymentItemConverter new];
    [itemConverter setPaymentProductFields:product.fields JSON:[rawProduct objectForKey:@"fields"]];
    return product;
}

@end
