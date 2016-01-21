//
//  GCPaymentProductsConverter.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 06/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCPaymentProductsConverter.h"
#import "GCBasicPaymentProductConverter.h"

@implementation GCPaymentProductsConverter

- (GCPaymentProducts *)paymentProductsFromJSON:(NSArray *)rawProducts
{
    GCPaymentProducts *products = [[GCPaymentProducts alloc] init];
    GCBasicPaymentProductConverter *converter = [[GCBasicPaymentProductConverter alloc] init];
    for (NSDictionary *rawProduct in rawProducts) {
        GCBasicPaymentProduct *product = [converter basicPaymentProductFromJSON:rawProduct];
        [products.paymentProducts addObject:product];
    }
    [products sort];
    return products;
}

@end
