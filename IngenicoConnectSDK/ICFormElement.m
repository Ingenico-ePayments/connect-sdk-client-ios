//
//  ICFormElement.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICFormElement.h"

@implementation ICFormElement

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.valueMapping = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
