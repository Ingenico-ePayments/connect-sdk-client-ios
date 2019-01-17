//
//  ICPaymentProductConverter.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <IngenicoConnectSDK/ICBasicPaymentProductConverter.h>

@implementation ICBasicPaymentProductConverter

- (ICBasicPaymentProduct *)basicPaymentProductFromJSON:(NSDictionary *)rawBasicProduct
{
    ICBasicPaymentProduct *basicProduct = [[ICBasicPaymentProduct alloc] init];
    [self setBasicPaymentProduct:basicProduct JSON:rawBasicProduct];
    return basicProduct;
}

- (void)setBasicPaymentProduct:(ICBasicPaymentProduct *)basicProduct JSON:(NSDictionary *)rawBasicProduct
{
    [super setBasicPaymentItem:basicProduct JSON:rawBasicProduct];
    basicProduct.allowsRecurring = [[rawBasicProduct objectForKey:@"allowsRecurring"] boolValue];
    basicProduct.allowsTokenization = [[rawBasicProduct objectForKey:@"allowsTokenization"] boolValue];
    basicProduct.autoTokenized = [[rawBasicProduct objectForKey:@"autoTokenized"] boolValue];
    basicProduct.paymentMethod = [rawBasicProduct objectForKey:@"paymentMethod"];
    basicProduct.paymentProductGroup = [rawBasicProduct objectForKey:@"paymentProductGroup"];

    if (rawBasicProduct[@"paymentProduct302SpecificData"] != nil) {
        ICPaymentProduct302SpecificData *paymentProduct302SpecificData = [[ICPaymentProduct302SpecificData alloc] init];
        [self setPaymentProduct302SpecificData:paymentProduct302SpecificData JSON:[rawBasicProduct objectForKey:@"paymentProduct302SpecificData"]];
        basicProduct.paymentProduct302SpecificData = paymentProduct302SpecificData;
    }
    if (rawBasicProduct[@"paymentProduct320SpecificData"] != nil) {
        ICPaymentProduct320SpecificData *paymentProduct320SpecificData = [[ICPaymentProduct320SpecificData alloc] init];
        [self setPaymentProduct320SpecificData:paymentProduct320SpecificData JSON:[rawBasicProduct objectForKey:@"paymentProduct320SpecificData"]];
        basicProduct.paymentProduct320SpecificData = paymentProduct320SpecificData;
    }
    if (rawBasicProduct[@"paymentProduct863SpecificData"] != nil) {
        ICPaymentProduct863SpecificData *paymentProduct863SpecificData = [[ICPaymentProduct863SpecificData alloc] init];
        [self setPaymentProduct863SpecificData:paymentProduct863SpecificData JSON:[rawBasicProduct objectForKey:@"paymentProduct863SpecificData"]];
        basicProduct.paymentProduct863SpecificData = paymentProduct863SpecificData;
    }
}

- (void)setPaymentProduct302SpecificData:(ICPaymentProduct302SpecificData *)paymentProduct302SpecificData JSON:(NSDictionary *)rawPaymentProduct302SpecificData
{
    NSArray *rawNetworks = [rawPaymentProduct302SpecificData objectForKey:@"networks"];
    for (NSString *network in rawNetworks) {
        [paymentProduct302SpecificData.networks addObject:network];
    }
}

- (void)setPaymentProduct320SpecificData:(ICPaymentProduct320SpecificData *)paymentProduct320SpecificData JSON:(NSDictionary *)rawPaymentProduct320SpecificData
{
    paymentProduct320SpecificData.gateway = [[rawAccount objectForKey:@"gateway"] stringValue];
    NSArray *rawNetworks = [rawPaymentProduct320SpecificData objectForKey:@"networks"];
    for (NSString *network in rawNetworks) {
        [paymentProduct320SpecificData.networks addObject:network];
    }
}

- (void)setPaymentProduct863SpecificData:(ICPaymentProduct863SpecificData *)paymentProduct863SpecificData JSON:(NSDictionary *)rawPaymentProduct863SpecificData
{
    NSArray *rawIntegrationTypes = [rawPaymentProduct863SpecificData objectForKey:@"integrationTypes"];
    for (NSString *integrationType in rawIntegrationTypes) {
        [paymentProduct863SpecificData.integrationTypes addObject:integrationType];
    }
}



@end
