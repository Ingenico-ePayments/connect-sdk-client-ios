//
//  GCBasicPaymentItemConverter.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 18/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import "GCBasicPaymentItemConverter.h"
#import "GCValidator.h"
#import "GCBasicPaymentItem.h"
#import "GCMacros.h"
#import "GCBasicPaymentProductConverter.h"
#import "GCAccountOnFileAttribute.h"
#import "GCLabelTemplateItem.h"

@implementation GCBasicPaymentItemConverter {

}

- (void)setBasicPaymentItem:(NSObject <GCBasicPaymentItem> *)paymentItem JSON:(NSDictionary *)rawPaymentItem {
    NSObject *identifier = [rawPaymentItem objectForKey:@"id"];
    if ([identifier isKindOfClass:[NSString class]]) {
        paymentItem.identifier = (NSString *) identifier;
    } else if ([identifier isKindOfClass:[NSNumber class]]) {
        paymentItem.identifier = [(NSNumber *)identifier stringValue];
    }

    [self setPaymentProductDisplayHints:paymentItem.displayHints JSON:[rawPaymentItem objectForKey:@"displayHints"]];
    [self setAccountsOnFile:paymentItem.accountsOnFile JSON:[rawPaymentItem objectForKey:@"accountsOnFile"]];
}

- (void)setPaymentProductDisplayHints:(GCPaymentItemDisplayHints *)displayHints JSON:(NSDictionary *)rawDisplayHints
{
    displayHints.displayOrder = [[rawDisplayHints objectForKey:@"displayOrder"] integerValue];
    displayHints.logoPath = [rawDisplayHints objectForKey:@"logo"];
}

- (void)setAccountsOnFile:(GCAccountsOnFile *)accountsOnFile JSON:(NSArray *)rawAccounts
{
    for (NSDictionary *rawAccount in rawAccounts) {
        GCAccountOnFile *account = [self accountOnFileFromJSON:rawAccount];
        [accountsOnFile.accountsOnFile addObject:account];
    }
}

- (GCAccountOnFile *)accountOnFileFromJSON:(NSDictionary *)rawAccount
{
    GCAccountOnFile *account = [[GCAccountOnFile alloc] init];
    account.identifier = [[rawAccount objectForKey:@"id"] stringValue];
    account.paymentProductIdentifier = [[rawAccount objectForKey:@"paymentProductId"] stringValue];
    [self setAccountOnFileDisplayHints:account.displayHints JSON:[rawAccount objectForKey:@"displayHints"]];
    [self setAttributes:account.attributes JSON:[rawAccount objectForKey:@"attributes"]];
    return account;
}

- (void)setAccountOnFileDisplayHints:(GCAccountOnFileDisplayHints *)displayHints JSON:(NSDictionary *)rawDisplayHints
{
    [self setLabelTemplate:displayHints.labelTemplate JSON:[rawDisplayHints objectForKey:@"labelTemplate"]];
}

- (void)setLabelTemplate:(GCLabelTemplate *)labelTemplate JSON:(NSArray *)rawLabelTemplate
{
    for (NSDictionary *rawLabelTemplateItem in rawLabelTemplate) {
        GCLabelTemplateItem *item = [self labelTemplateItemFromJSON:rawLabelTemplateItem];
        [labelTemplate.labelTemplateItems addObject:item];
    }
}

- (GCLabelTemplateItem *)labelTemplateItemFromJSON:(NSDictionary *)rawLabelTemplateItem
{
    GCLabelTemplateItem *item = [[GCLabelTemplateItem alloc] init];
    item.attributeKey = [rawLabelTemplateItem objectForKey:@"attributeKey"];
    item.mask = [rawLabelTemplateItem objectForKey:@"mask"];
    return item;
}

- (void)setAttributes:(GCAccountOnFileAttributes *)attributes JSON:(NSArray *)rawAttributes
{
    for (NSDictionary *rawAttribute in rawAttributes) {
        GCAccountOnFileAttribute *attribute = [self attributeFromJSON:rawAttribute];
        [attributes.attributes addObject:attribute];
    }
}

- (GCAccountOnFileAttribute *)attributeFromJSON:(NSDictionary *)rawAttribute
{
    GCAccountOnFileAttribute *attribute = [[GCAccountOnFileAttribute alloc] init];
    attribute.key = [rawAttribute objectForKey:@"key"];
    attribute.value = [rawAttribute objectForKey:@"value"];
    NSString *rawStatus = [rawAttribute objectForKey:@"status"];
    if ([rawStatus isEqualToString:@"READ_ONLY"] == YES) {
        attribute.status = GCReadOnly;
    } else if ([rawStatus isEqualToString:@"CAN_WRITE"] == YES) {
        attribute.status = GCCanWrite;
    } else if ([rawStatus isEqualToString:@"MUST_WRITE"] == YES) {
        attribute.status = GCMustWrite;
    } else {
        DLog(@"Status %@ in JSON fragment %@ is invalid", rawStatus, rawAttribute);
    }
    attribute.mustWriteReason = [rawAttribute objectForKey:@"mustWriteReason"];

    return attribute;
}

@end
