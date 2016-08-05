//
//  GCAssetManager.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 03/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCBasicPaymentProducts.h"
#import "GCPaymentProduct.h"

@class GCPaymentItems;

@interface GCAssetManager : NSObject

- (void)initializeImagesForPaymentItems:(NSArray *)paymentItems;
- (void)initializeImagesForPaymentItem:(NSObject<GCPaymentItem> *)paymentItem;
- (void)updateImagesForPaymentItemsAsynchronously:(NSArray *)paymentItems baseURL:(NSString *)baseURL;
- (void)updateImagesForPaymentItemAsynchronously:(NSObject<GCPaymentItem> *)paymentItem baseURL:(NSString *)baseURL;
- (UIImage *)logoImageForPaymentItem:(NSString *)paymentItemId;
- (UIImage *)tooltipImageForPaymentItem:(NSString *)paymentItemId field:(NSString *)paymentProductFieldId;

@end
