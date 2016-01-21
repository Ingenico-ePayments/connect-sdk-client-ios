//
//  GCDirectoryEntries.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 17/03/15.
//  Copyright (c) 2015 Global Collect Services B.V. All rights reserved.
//

#import "GCDirectoryEntries.h"

@implementation GCDirectoryEntries

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.directoryEntries = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
