//
//  ICDirectoryEntries.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICDirectoryEntries.h"

@implementation ICDirectoryEntries

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.directoryEntries = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
