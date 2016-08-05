//
//  GCPaymentItems.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 19/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCStringFormatter;
@protocol GCBasicPaymentItem;
@class GCBasicPaymentProducts;
@class GCBasicPaymentProductGroups;


@interface GCPaymentItems : NSObject

@property (nonatomic, strong) NSMutableArray *paymentItems;

- (instancetype)initWithPaymentProducts:(GCBasicPaymentProducts *)products groups:(GCBasicPaymentProductGroups *)groups;

- (BOOL)hasAccountsOnFile;
- (NSArray *)accountsOnFile;
- (NSObject<GCBasicPaymentItem> *)paymentItemWithIdentifier:(NSString *)paymentItemIdentifier;
- (void)sort;

@end
