//
//  ICBasicPaymentProductsConverter.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICBasicPaymentProductsConverter.h"
#import  "ICBasicPaymentProductConverter.h"

@implementation ICBasicPaymentProductsConverter

- (ICBasicPaymentProducts *)paymentProductsFromJSON:(NSArray *)rawProducts
{
    ICBasicPaymentProducts *products = [[ICBasicPaymentProducts alloc] init];
    ICBasicPaymentProductConverter *converter = [[ICBasicPaymentProductConverter alloc] init];
    for (NSDictionary *rawProduct in rawProducts) {
        ICBasicPaymentProduct *product = [converter basicPaymentProductFromJSON:rawProduct];
        [products.paymentProducts addObject:product];
    }
    [products sort];
    return products;
}

@end
