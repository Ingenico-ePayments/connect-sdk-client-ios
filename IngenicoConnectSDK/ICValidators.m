//
//  ICValidators.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICValidators.h"

@implementation ICValidators

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.validators = [[NSMutableArray alloc] init];
        self.containsSomeTimesRequiredValidator = NO;
    }
    return self;
}

@end
