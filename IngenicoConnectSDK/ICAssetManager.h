//
//  ICAssetManager.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <IngenicoConnectSDK/ICBasicPaymentProducts.h>
#import <IngenicoConnectSDK/ICPaymentProduct.h>

@class ICPaymentItems;

@interface ICAssetManager : NSObject

- (void)initializeImagesForPaymentItems:(NSArray *)paymentItems;
- (void)initializeImagesForPaymentItem:(NSObject<ICPaymentItem> *)paymentItem;
- (void)updateImagesForPaymentItemsAsynchronously:(NSArray *)paymentItems baseURL:(NSString *)baseURL;
- (void)updateImagesForPaymentItemAsynchronously:(NSObject<ICPaymentItem> *)paymentItem baseURL:(NSString *)baseURL;
- (void)updateImagesForPaymentItemsAsynchronously:(NSArray *)paymentItems baseURL:(NSString *)baseURL callback:(void(^)())callback;
- (void)updateImagesForPaymentItemAsynchronously:(NSObject<ICPaymentItem> *)paymentItem baseURL:(NSString *)baseURL callback:(void(^)())callback;
- (UIImage *)logoImageForPaymentItem:(NSString *)paymentItemId;
- (UIImage *)tooltipImageForPaymentItem:(NSString *)paymentItemId field:(NSString *)paymentProductFieldId;

@end
