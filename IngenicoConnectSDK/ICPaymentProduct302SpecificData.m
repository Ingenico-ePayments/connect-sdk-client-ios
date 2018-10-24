//
//  ICPaymentProduct302SpecificData.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 18/09/2018.
//  Copyright © 2018 Global Collect Services. All rights reserved.
//

#import <IngenicoConnectSDK/ICPaymentProduct302SpecificData.h>

@implementation ICPaymentProduct302SpecificData

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.networks = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
