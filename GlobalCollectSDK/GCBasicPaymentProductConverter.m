//
//  GCPaymentProductConverter.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 06/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCBasicPaymentProductConverter.h"

@implementation GCBasicPaymentProductConverter

- (GCBasicPaymentProduct *)basicPaymentProductFromJSON:(NSDictionary *)rawBasicProduct
{
    GCBasicPaymentProduct *basicProduct = [[GCBasicPaymentProduct alloc] init];
    [self setBasicPaymentProduct:basicProduct JSON:rawBasicProduct];
    return basicProduct;
}

- (void)setBasicPaymentProduct:(GCBasicPaymentProduct *)basicProduct JSON:(NSDictionary *)rawBasicProduct
{
    [super setBasicPaymentItem:basicProduct JSON:rawBasicProduct];
    basicProduct.allowsRecurring = [[rawBasicProduct objectForKey:@"allowsRecurring"] boolValue];
    basicProduct.allowsTokenization = [[rawBasicProduct objectForKey:@"allowsTokenization"] boolValue];
    basicProduct.autoTokenized = [[rawBasicProduct objectForKey:@"autoTokenized"] boolValue];
    basicProduct.paymentMethod = [rawBasicProduct objectForKey:@"paymentMethod"];
    basicProduct.paymentProductGroup = [rawBasicProduct objectForKey:@"paymentProductGroup"];
}



@end
