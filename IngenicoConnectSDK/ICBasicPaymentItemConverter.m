//
//  ICBasicPaymentItemConverter.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICBasicPaymentItemConverter.h"
#import  "ICValidator.h"
#import  "ICBasicPaymentItem.h"
#import  "ICMacros.h"
#import  "ICBasicPaymentProductConverter.h"
#import  "ICAccountOnFileAttribute.h"
#import  "ICLabelTemplateItem.h"

@implementation ICBasicPaymentItemConverter {

}

- (void)setBasicPaymentItem:(NSObject <ICBasicPaymentItem> *)paymentItem JSON:(NSDictionary *)rawPaymentItem {
    NSObject *identifier = [rawPaymentItem objectForKey:@"id"];
    if ([identifier isKindOfClass:[NSString class]]) {
        paymentItem.identifier = (NSString *) identifier;
    } else if ([identifier isKindOfClass:[NSNumber class]]) {
        paymentItem.identifier = [(NSNumber *)identifier stringValue];
    }

    [self setPaymentProductDisplayHints:paymentItem.displayHints JSON:[rawPaymentItem objectForKey:@"displayHints"]];
    [self setAccountsOnFile:paymentItem.accountsOnFile JSON:[rawPaymentItem objectForKey:@"accountsOnFile"]];
    paymentItem.acquirerCountry = [rawPaymentItem objectForKey:@"acquirerCountry"];
}

- (void)setPaymentProductDisplayHints:(ICPaymentItemDisplayHints *)displayHints JSON:(NSDictionary *)rawDisplayHints
{
    displayHints.displayOrder = [[rawDisplayHints objectForKey:@"displayOrder"] integerValue];
    displayHints.label = [[rawDisplayHints objectForKey:@"label"] stringValue];
    displayHints.logoPath = [rawDisplayHints objectForKey:@"logo"];
}

- (void)setAccountsOnFile:(ICAccountsOnFile *)accountsOnFile JSON:(NSArray *)rawAccounts
{
    for (NSDictionary *rawAccount in rawAccounts) {
        ICAccountOnFile *account = [self accountOnFileFromJSON:rawAccount];
        [accountsOnFile.accountsOnFile addObject:account];
    }
}

- (ICAccountOnFile *)accountOnFileFromJSON:(NSDictionary *)rawAccount
{
    ICAccountOnFile *account = [[ICAccountOnFile alloc] init];
    account.identifier = [[rawAccount objectForKey:@"id"] stringValue];
    account.paymentProductIdentifier = [[rawAccount objectForKey:@"paymentProductId"] stringValue];
    [self setAccountOnFileDisplayHints:account.displayHints JSON:[rawAccount objectForKey:@"displayHints"]];
    [self setAttributes:account.attributes JSON:[rawAccount objectForKey:@"attributes"]];
    return account;
}

- (void)setAccountOnFileDisplayHints:(ICAccountOnFileDisplayHints *)displayHints JSON:(NSDictionary *)rawDisplayHints
{
    [self setLabelTemplate:displayHints.labelTemplate JSON:[rawDisplayHints objectForKey:@"labelTemplate"]];
    displayHints.logo = [[rawDisplayHints objectForKey:@"logo"] stringValue];
}

- (void)setLabelTemplate:(ICLabelTemplate *)labelTemplate JSON:(NSArray *)rawLabelTemplate
{
    for (NSDictionary *rawLabelTemplateItem in rawLabelTemplate) {
        ICLabelTemplateItem *item = [self labelTemplateItemFromJSON:rawLabelTemplateItem];
        [labelTemplate.labelTemplateItems addObject:item];
    }
}

- (ICLabelTemplateItem *)labelTemplateItemFromJSON:(NSDictionary *)rawLabelTemplateItem
{
    ICLabelTemplateItem *item = [[ICLabelTemplateItem alloc] init];
    item.attributeKey = [rawLabelTemplateItem objectForKey:@"attributeKey"];
    item.mask = [rawLabelTemplateItem objectForKey:@"mask"];
    return item;
}

- (void)setAttributes:(ICAccountOnFileAttributes *)attributes JSON:(NSArray *)rawAttributes
{
    for (NSDictionary *rawAttribute in rawAttributes) {
        ICAccountOnFileAttribute *attribute = [self attributeFromJSON:rawAttribute];
        [attributes.attributes addObject:attribute];
    }
}

- (ICAccountOnFileAttribute *)attributeFromJSON:(NSDictionary *)rawAttribute
{
    ICAccountOnFileAttribute *attribute = [[ICAccountOnFileAttribute alloc] init];
    attribute.key = [rawAttribute objectForKey:@"key"];
    attribute.value = [rawAttribute objectForKey:@"value"];
    NSString *rawStatus = [rawAttribute objectForKey:@"status"];
    if ([rawStatus isEqualToString:@"READ_ONLY"] == YES) {
        attribute.status = ICReadOnly;
    } else if ([rawStatus isEqualToString:@"CAN_WRITE"] == YES) {
        attribute.status = ICCanWrite;
    } else if ([rawStatus isEqualToString:@"MUST_WRITE"] == YES) {
        attribute.status = ICMustWrite;
    } else {
        DLog(@"Status %@ in JSON fragment %@ is invalid", rawStatus, rawAttribute);
    }
    attribute.mustWriteReason = [rawAttribute objectForKey:@"mustWriteReason"];

    return attribute;
}

@end
