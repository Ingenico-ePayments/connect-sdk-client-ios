//
//  ICDataRestrictions.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <IngenicoConnectSDK/ICDataRestrictions.h>

@implementation ICDataRestrictions

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.validators = [[ICValidators alloc] init];
    }
    return self;
}

@end
