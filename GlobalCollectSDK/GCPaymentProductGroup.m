//
//  GCPaymentProductGroup.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 18/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import "GCPaymentProductGroup.h"
#import "GCPaymentItemDisplayHints.h"
#import "GCAccountsOnFile.h"
#import "GCPaymentProductField.h"
#import "GCPaymentProductFields.h"

@implementation GCPaymentProductGroup {

}

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.displayHints = [[GCPaymentItemDisplayHints alloc] init];
        self.accountsOnFile = [[GCAccountsOnFile alloc] init];
        self.fields = [GCPaymentProductFields new];
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

- (GCPaymentProductField *)paymentProductFieldWithId:(NSString *)paymentProductFieldId
{
    for (GCPaymentProductField *field in self.fields.paymentProductFields) {
        if ([field.identifier isEqualToString:paymentProductFieldId] == YES) {
            return field;
        }
    }
    return nil;
}

@end
