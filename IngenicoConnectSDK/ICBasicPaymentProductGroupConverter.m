//
//  ICBasicPaymentProductGroupConverter.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <IngenicoConnectSDK/ICBasicPaymentProductGroupConverter.h>
#import <IngenicoConnectSDK/ICBasicPaymentProductGroup.h>

@implementation ICBasicPaymentProductGroupConverter

- (ICBasicPaymentProductGroup *)paymentProductGroupFromJSON:(NSDictionary *)rawProductGroup {
    ICBasicPaymentProductGroup *paymentProductGroup = [ICBasicPaymentProductGroup new];
    [super setBasicPaymentItem:paymentProductGroup JSON:rawProductGroup];
    return paymentProductGroup;
}

@end
