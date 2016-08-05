//
//  GCTableSectionConverter.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 10/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCSDKConstants.h"
#import "GCTableSectionConverter.h"
#import "GCPaymentProductsTableRow.h"
#import "GCPaymentItems.h"
#import "GCBasicPaymentProductGroup.h"

@implementation GCTableSectionConverter

+ (GCPaymentProductsTableSection *)paymentProductsTableSectionFromAccountsOnFile:(NSArray *)accountsOnFile paymentItems:(GCPaymentItems *)paymentItems
{
    GCPaymentProductsTableSection *section = [[GCPaymentProductsTableSection alloc] init];
    section.type = GCAccountOnFileType;
    for (GCAccountOnFile *accountOnFile in accountsOnFile) {
        id<GCBasicPaymentItem> product = [paymentItems paymentItemWithIdentifier:accountOnFile.paymentProductIdentifier];
        GCPaymentProductsTableRow *row = [[GCPaymentProductsTableRow alloc] init];
        NSString *displayName = [accountOnFile label];
        row.name = displayName;
        row.accountOnFileIdentifier = accountOnFile.identifier;
        row.paymentProductIdentifier = accountOnFile.paymentProductIdentifier;
        row.logo = product.displayHints.logoImage;
        [section.rows addObject:row];
    }
    return section;
}

+ (GCPaymentProductsTableSection *)paymentProductsTableSectionFromPaymentItems:(GCPaymentItems *)paymentItems
{
    NSString *sdkBundlePath = [[NSBundle mainBundle] pathForResource:@"GlobalCollectSDK" ofType:@"bundle"];
    NSBundle *sdkBundle = [NSBundle bundleWithPath:sdkBundlePath];
    
    GCPaymentProductsTableSection *section = [[GCPaymentProductsTableSection alloc] init];
    for (NSObject<GCPaymentItem> *paymentItem in paymentItems.paymentItems) {
        section.type = GCPaymentProductType;
        GCPaymentProductsTableRow *row = [[GCPaymentProductsTableRow alloc] init];
        NSString *paymentProductKey = [self localizationKeyWithPaymentItem:paymentItem];
        NSString *paymentProductValue = NSLocalizedStringFromTableInBundle(paymentProductKey, kGCSDKLocalizable, sdkBundle, nil);
        row.name = paymentProductValue;
        row.accountOnFileIdentifier = @"";
        row.paymentProductIdentifier = paymentItem.identifier;
        row.logo = paymentItem.displayHints.logoImage;
        [section.rows addObject:row];
    }
    return section;
}

+ (NSString *)localizationKeyWithPaymentItem:(NSObject<GCBasicPaymentItem> *)paymentItem {
    if ([paymentItem isKindOfClass:[GCBasicPaymentProduct class]]) {
        return [NSString stringWithFormat:@"gc.general.paymentProducts.%@.name", paymentItem.identifier];
    }
    else if ([paymentItem isKindOfClass:[GCBasicPaymentProductGroup class]]) {
        return [NSString stringWithFormat:@"gc.general.paymentProductGroups.%@.name", paymentItem.identifier];
    }
    else {
        return @"";
    }
}

@end
