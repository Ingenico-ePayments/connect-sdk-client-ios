//
//  GCBasicPaymentProductConverter.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 06/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCBasicPaymentProduct.h"
#import "GCAssetManager.h"
#import "GCStringFormatter.h"
#import "GCBasicPaymentItemConverter.h"

@interface GCBasicPaymentProductConverter : GCBasicPaymentItemConverter

- (GCBasicPaymentProduct *)basicPaymentProductFromJSON:(NSDictionary *)rawBasicProduct;
- (void)setBasicPaymentProduct:(GCBasicPaymentProduct *)basicProduct JSON:(NSDictionary *)rawBasicProduct;

@end
