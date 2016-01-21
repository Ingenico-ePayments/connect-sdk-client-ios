//
//  GCDirectoryEntryConverter.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 17/03/15.
//  Copyright (c) 2015 Global Collect Services B.V. All rights reserved.
//

#import "GCDirectoryEntryConverter.h"

@implementation GCDirectoryEntryConverter

- (GCDirectoryEntry *)directoryEntryFromJSON:(NSDictionary *)rawDirectoryEntry
{
    GCDirectoryEntry *entry = [[GCDirectoryEntry alloc] init];
    [entry.countryNames addObjectsFromArray:[rawDirectoryEntry objectForKey:@"countryNames"]];
    entry.issuerIdentifier = [rawDirectoryEntry objectForKey:@"issuerId"];
    entry.issuerList = [rawDirectoryEntry objectForKey:@"issuerList"];
    entry.issuerName = [rawDirectoryEntry objectForKey:@"issuerName"];
    return entry;
}

@end
