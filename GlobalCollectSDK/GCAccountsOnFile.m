//
//  GCAccountsOnFile.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCAccountsOnFile.h"

@implementation GCAccountsOnFile

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.accountsOnFile = [[NSMutableArray alloc] init];
    }
    return self;
}

- (GCAccountOnFile *)accountOnFileWithIdentifier:(NSString *)accountOnFileIdentifier
{
    for (GCAccountOnFile *accountOnFile in self.accountsOnFile) {
        if ([accountOnFile.identifier isEqualToString:accountOnFileIdentifier] == YES) {
            return accountOnFile;
        }
    }
    return nil;
}

@end
