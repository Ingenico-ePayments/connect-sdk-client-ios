//
//  GCDirectoryEntriesConverter.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 17/03/15.
//  Copyright (c) 2015 Global Collect Services B.V. All rights reserved.
//

#import "GCDirectoryEntriesConverter.h"
#import "GCDirectoryEntryConverter.h"

@implementation GCDirectoryEntriesConverter

- (GCDirectoryEntries *)directoryEntriesFromJSON:(NSArray *)rawDirectoryEntries {
    GCDirectoryEntries *entries = [[GCDirectoryEntries alloc] init];
    GCDirectoryEntryConverter *converter = [[GCDirectoryEntryConverter alloc] init];
    for (NSDictionary *rawEntry in rawDirectoryEntries) {
        GCDirectoryEntry *entry = [converter directoryEntryFromJSON:rawEntry];
        [entries.directoryEntries addObject:entry];
    }
    return entries;
}

@end
