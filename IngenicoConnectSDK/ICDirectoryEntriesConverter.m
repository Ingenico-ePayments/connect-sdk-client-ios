//
//  ICDirectoryEntriesConverter.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICDirectoryEntriesConverter.h"
#import  "ICDirectoryEntryConverter.h"

@implementation ICDirectoryEntriesConverter

- (ICDirectoryEntries *)directoryEntriesFromJSON:(NSArray *)rawDirectoryEntries {
    ICDirectoryEntries *entries = [[ICDirectoryEntries alloc] init];
    ICDirectoryEntryConverter *converter = [[ICDirectoryEntryConverter alloc] init];
    for (NSDictionary *rawEntry in rawDirectoryEntries) {
        ICDirectoryEntry *entry = [converter directoryEntryFromJSON:rawEntry];
        [entries.directoryEntries addObject:entry];
    }
    return entries;
}

@end
