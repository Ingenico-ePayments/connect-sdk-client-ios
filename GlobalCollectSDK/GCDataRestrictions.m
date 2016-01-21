//
//  GCDataRestrictions.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCDataRestrictions.h"

@implementation GCDataRestrictions

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.validators = [[GCValidators alloc] init];
    }
    return self;
}

@end
