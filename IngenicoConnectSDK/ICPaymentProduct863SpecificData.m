//
//  ICPaymentProduct863SpecificData.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 18/09/2018.
//  Copyright © 2018 Global Collect Services. All rights reserved.
//

#import  "ICPaymentProduct863SpecificData.h"

@implementation ICPaymentProduct863SpecificData

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.integrationTypes = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
