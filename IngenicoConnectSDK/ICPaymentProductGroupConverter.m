//
//  ICPaymentProductGroupConverter.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <IngenicoConnectSDK/ICPaymentProductGroupConverter.h>
#import <IngenicoConnectSDK/ICPaymentProductGroup.h>

@implementation ICPaymentProductGroupConverter {

}

- (ICPaymentProductGroup *)paymentProductGroupFromJSON:(NSDictionary *)rawProductGroup {
    ICPaymentProductGroup *paymentProductGroup = [ICPaymentProductGroup new];
    [super setPaymentItem:paymentProductGroup JSON:rawProductGroup];
    return paymentProductGroup;
}

@end
