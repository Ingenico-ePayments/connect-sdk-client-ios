//
//  ICAccountsOnFile.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICAccountsOnFile.h"

@implementation ICAccountsOnFile

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.accountsOnFile = [[NSMutableArray alloc] init];
    }
    return self;
}

- (ICAccountOnFile *)accountOnFileWithIdentifier:(NSString *)accountOnFileIdentifier
{
    for (ICAccountOnFile *accountOnFile in self.accountsOnFile) {
        if ([accountOnFile.identifier isEqualToString:accountOnFileIdentifier] == YES) {
            return accountOnFile;
        }
    }
    return nil;
}

@end
