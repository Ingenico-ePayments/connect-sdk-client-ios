//
//  GCBasicPaymentProductGroup.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 20/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import "GCBasicPaymentProductGroup.h"
#import "GCPaymentItemDisplayHints.h"
#import "GCAccountsOnFile.h"

@implementation GCBasicPaymentProductGroup {

}

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.displayHints = [[GCPaymentItemDisplayHints alloc] init];
        self.accountsOnFile = [[GCAccountsOnFile alloc] init];
    }
    return self;
}

- (GCAccountOnFile *)accountOnFileWithIdentifier:(NSString *)accountOnFileIdentifier
{
    return [self.accountsOnFile accountOnFileWithIdentifier:accountOnFileIdentifier];
}

- (void)setStringFormatter:(GCStringFormatter *)stringFormatter
{
    for (GCAccountOnFile *accountOnFile in self.accountsOnFile.accountsOnFile) {
        accountOnFile.stringFormatter = stringFormatter;
    }
}

@end
