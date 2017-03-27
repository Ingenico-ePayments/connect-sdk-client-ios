//
//  ICPaymentItems.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICStringFormatter;
@protocol ICBasicPaymentItem;
@class ICBasicPaymentProducts;
@class ICBasicPaymentProductGroups;


@interface ICPaymentItems : NSObject

@property (nonatomic, strong) NSMutableArray *paymentItems;

- (instancetype)initWithPaymentProducts:(ICBasicPaymentProducts *)products groups:(ICBasicPaymentProductGroups *)groups;

- (BOOL)hasAccountsOnFile;
- (NSArray *)accountsOnFile;
- (NSObject<ICBasicPaymentItem> *)paymentItemWithIdentifier:(NSString *)paymentItemIdentifier;
- (void)sort;

@end
