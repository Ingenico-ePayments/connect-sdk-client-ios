//
//  GCAssetManager.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 03/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCPaymentProducts.h"
#import "GCPaymentProduct.h"

@interface GCAssetManager : NSObject

- (void)initializeImagesForPaymentProducts:(GCPaymentProducts *)paymentProducts;
- (void)initializeImagesForPaymentProduct:(GCPaymentProduct *)paymentProduct;
- (void)updateImagesForPaymentProductsAsynchronously:(GCPaymentProducts *)paymentProducts baseURL:(NSString *)baseURL;
- (void)updateImagesForPaymentProductAsynchronously:(GCPaymentProduct *)paymentProduct baseURL:(NSString *)baseURL;
- (UIImage *)logoImageForPaymentProduct:(NSString *)paymentProductId;
- (UIImage *)tooltipImageForPaymentProduct:(NSString *)paymentProductId field:(NSString *)paymentProductFieldId;

@end
