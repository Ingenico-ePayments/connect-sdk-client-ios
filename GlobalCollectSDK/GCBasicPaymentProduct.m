//
//  GCBasicPaymentProduct.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCBasicPaymentProduct.h"

@interface GCBasicPaymentProduct ()

@property (strong, nonatomic) GCStringFormatter *stringFormatter;

@end

@implementation GCBasicPaymentProduct

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.displayHints = [[GCPaymentProductDisplayHints alloc] init];
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
