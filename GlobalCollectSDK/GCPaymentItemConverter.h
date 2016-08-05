//
//  GCPaymentItemConverter.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 20/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCBasicPaymentItemConverter.h"

@protocol GCPaymentItem;

@interface GCPaymentItemConverter : GCBasicPaymentItemConverter

- (void)setPaymentItem:(NSObject <GCPaymentItem> *)paymentItem JSON:(NSDictionary *)rawPaymentItem;

- (void)setPaymentProductFields:(GCPaymentProductFields *)fields JSON:(NSArray *)rawFields;

@end
