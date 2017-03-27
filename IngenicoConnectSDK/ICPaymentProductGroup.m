//
//  ICPaymentProductGroup.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <IngenicoConnectSDK/ICPaymentProductGroup.h>
#import <IngenicoConnectSDK/ICPaymentItemDisplayHints.h>
#import <IngenicoConnectSDK/ICAccountsOnFile.h>
#import <IngenicoConnectSDK/ICPaymentProductField.h>
#import <IngenicoConnectSDK/ICPaymentProductFields.h>

@implementation ICPaymentProductGroup {

}

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.displayHints = [[ICPaymentItemDisplayHints alloc] init];
        self.accountsOnFile = [[ICAccountsOnFile alloc] init];
        self.fields = [ICPaymentProductFields new];
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

- (ICPaymentProductField *)paymentProductFieldWithId:(NSString *)paymentProductFieldId
{
    for (ICPaymentProductField *field in self.fields.paymentProductFields) {
        if ([field.identifier isEqualToString:paymentProductFieldId] == YES) {
            return field;
        }
    }
    return nil;
}

@end
