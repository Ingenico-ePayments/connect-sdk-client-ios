//
//  GCTableSectionConverter.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 10/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCPaymentProductsTableSection.h"
#import "GCPaymentProducts.h"

@interface GCTableSectionConverter : NSObject

+ (GCPaymentProductsTableSection *)paymentProductsTableSectionFromAccountsOnFile:(NSArray *)accountsOnFile paymentProducts:(GCPaymentProducts *)paymentProducts;
+ (GCPaymentProductsTableSection *)paymentProductsTableSectionFromPaymentProducts:(GCPaymentProducts *)paymentProducts;

@end
