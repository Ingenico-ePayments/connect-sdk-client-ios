//
//  GCPaymentProductNetworks.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 18/10/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import "GCPaymentProductNetworks.h"

@implementation GCPaymentProductNetworks

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.paymentProductNetworks = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
