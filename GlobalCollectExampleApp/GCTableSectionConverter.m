//
//  GCTableSectionConverter.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 10/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCSDKConstants.h"
#import "GCMacros.h"
#import "GCTableSectionConverter.h"
#import "GCAccountOnFile.h"
#import "GCPaymentProductsTableRow.h"
#import "GCAccountOnFileAttribute.h"
#import "GCPaymentProduct.h"
#import "GCLabelTemplateItem.h"

@implementation GCTableSectionConverter

+ (GCPaymentProductsTableSection *)paymentProductsTableSectionFromAccountsOnFile:(NSArray *)accountsOnFile paymentProducts:(GCPaymentProducts *)paymentProducts
{
    GCPaymentProductsTableSection *section = [[GCPaymentProductsTableSection alloc] init];
    section.type = GCAccountOnFileType;
    for (GCAccountOnFile *accountOnFile in accountsOnFile) {
        GCBasicPaymentProduct *product = [paymentProducts paymentProductWithIdentifier:accountOnFile.paymentProductIdentifier];
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

+ (GCPaymentProductsTableSection *)paymentProductsTableSectionFromPaymentProducts:(GCPaymentProducts *)paymentProducts
{
    NSString *sdkBundlePath = [[NSBundle mainBundle] pathForResource:@"GlobalCollectSDK" ofType:@"bundle"];
    NSBundle *sdkBundle = [NSBundle bundleWithPath:sdkBundlePath];
    
    GCPaymentProductsTableSection *section = [[GCPaymentProductsTableSection alloc] init];
    for (GCBasicPaymentProduct *product in paymentProducts.paymentProducts) {
        section.type = GCPaymentProductType;
        GCPaymentProductsTableRow *row = [[GCPaymentProductsTableRow alloc] init];
        NSString *paymentProductKey = [NSString stringWithFormat:@"gc.general.paymentProducts.%@.name", product.identifier];
        NSString *paymentProductValue = NSLocalizedStringFromTableInBundle(paymentProductKey, kGCSDKLocalizable, sdkBundle, nil);
        row.name = paymentProductValue;
        row.accountOnFileIdentifier = @"";
        row.paymentProductIdentifier = product.identifier;
        row.logo = product.displayHints.logoImage;
        [section.rows addObject:row];
    }
    return section;
}

@end
