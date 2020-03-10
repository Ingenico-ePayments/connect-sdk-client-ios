//
//  ICPaymentProductNetworks.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICPaymentProductNetworks.h"

@implementation ICPaymentProductNetworks

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.paymentProductNetworks = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
