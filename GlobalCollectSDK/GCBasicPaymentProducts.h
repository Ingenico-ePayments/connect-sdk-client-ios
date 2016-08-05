//
//  GCBasicPaymentProducts.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCBasicPaymentProduct.h"

@interface GCBasicPaymentProducts : NSObject

@property (strong, nonatomic) NSMutableArray *paymentProducts;

- (BOOL)hasAccountsOnFile;
- (NSArray *)accountsOnFile;
- (GCBasicPaymentProduct *)paymentProductWithIdentifier:(NSString *)paymentProductIdentifier;
- (void)sort;
- (void)setStringFormatter:(GCStringFormatter *)stringFormatter;

@end
