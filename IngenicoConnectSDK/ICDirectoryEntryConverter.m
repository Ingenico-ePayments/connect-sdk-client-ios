//
//  ICDirectoryEntryConverter.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICDirectoryEntryConverter.h"

@implementation ICDirectoryEntryConverter

- (ICDirectoryEntry *)directoryEntryFromJSON:(NSDictionary *)rawDirectoryEntry
{
    ICDirectoryEntry *entry = [[ICDirectoryEntry alloc] init];
    [entry.countryNames addObjectsFromArray:[rawDirectoryEntry objectForKey:@"countryNames"]];
    entry.issuerIdentifier = [rawDirectoryEntry objectForKey:@"issuerId"];
    entry.issuerList = [rawDirectoryEntry objectForKey:@"issuerList"];
    entry.issuerName = [rawDirectoryEntry objectForKey:@"issuerName"];
    return entry;
}

@end
