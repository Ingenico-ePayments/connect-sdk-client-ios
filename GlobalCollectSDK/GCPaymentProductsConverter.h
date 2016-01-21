//
//  GCPaymentProductsConverter.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 06/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCPaymentProducts.h"
#import "GCAssetManager.h"
#import "GCStringFormatter.h"

@interface GCPaymentProductsConverter : NSObject

- (GCPaymentProducts *)paymentProductsFromJSON:(NSArray *)rawProducts;

@end
