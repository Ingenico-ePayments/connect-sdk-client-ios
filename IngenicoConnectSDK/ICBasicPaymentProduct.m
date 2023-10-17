//
//  ICBasicPaymentProduct.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICBasicPaymentProduct.h"

@interface ICBasicPaymentProduct ()

@property (strong, nonatomic) ICStringFormatter *stringFormatter;

@end

@implementation ICBasicPaymentProduct

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.displayHints = [[ICPaymentItemDisplayHints alloc] init];
        self.accountsOnFile = [[ICAccountsOnFile alloc] init];
        self.authenticationIndicator = [[ICAuthenticationIndicator alloc] init];
    }
    return self;
}

- (ICAccountOnFile *)accountOnFileWithIdentifier:(NSString *)accountOnFileIdentifier
{
    return [self.accountsOnFile accountOnFileWithIdentifier:accountOnFileIdentifier];
}

- (void)setStringFormatter:(ICStringFormatter *)stringFormatter
{
    for (ICAccountOnFile *accountOnFile in self.accountsOnFile.accountsOnFile) {
        accountOnFile.stringFormatter = stringFormatter;
    }
}

@end
