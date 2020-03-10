//
//  ICPaymentProductConverter.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICPaymentProductConverter.h"

@implementation ICPaymentProductConverter

- (ICPaymentProduct *)paymentProductFromJSON:(NSDictionary *)rawProduct
{
    ICPaymentProduct *product = [[ICPaymentProduct alloc] init];
    [super setBasicPaymentProduct:product JSON:rawProduct];

    ICPaymentItemConverter *itemConverter = [ICPaymentItemConverter new];
    [itemConverter setPaymentProductFields:product.fields JSON:[rawProduct objectForKey:@"fields"]];
    return product;
}

@end
