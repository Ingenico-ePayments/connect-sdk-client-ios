//
//  GCDirectoryEntry.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 17/03/15.
//  Copyright (c) 2015 Global Collect Services B.V. All rights reserved.
//

#import "GCDirectoryEntry.h"

@implementation GCDirectoryEntry

- (instancetype) init
{
    self = [super init];
    if (self != nil) {
        self.countryNames = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
