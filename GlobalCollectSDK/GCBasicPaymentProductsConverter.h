//
//  GCBasicPaymentProductsConverter.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 06/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCBasicPaymentProducts.h"
#import "GCAssetManager.h"
#import "GCStringFormatter.h"

@interface GCBasicPaymentProductsConverter : NSObject

- (GCBasicPaymentProducts *)paymentProductsFromJSON:(NSArray *)rawProducts;

@end
