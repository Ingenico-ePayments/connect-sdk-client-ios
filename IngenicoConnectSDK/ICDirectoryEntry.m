//
//  ICDirectoryEntry.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICDirectoryEntry.h"

@implementation ICDirectoryEntry

- (instancetype) init
{
    self = [super init];
    if (self != nil) {
        self.countryNames = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
