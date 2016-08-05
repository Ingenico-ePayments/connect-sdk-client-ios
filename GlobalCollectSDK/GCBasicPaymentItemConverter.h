//
//  GCBasicPaymentItemConverter.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 18/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCPaymentProductFields;
@protocol GCBasicPaymentItem;


@interface GCBasicPaymentItemConverter : NSObject

- (void)setBasicPaymentItem:(NSObject <GCBasicPaymentItem> *)paymentItem JSON:(NSDictionary *)rawPaymentItem;

@end
