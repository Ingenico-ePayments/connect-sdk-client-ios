//
//  ICPaymentItemConverter.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  "ICBasicPaymentItemConverter.h"

@protocol ICPaymentItem;

@interface ICPaymentItemConverter : ICBasicPaymentItemConverter

- (void)setPaymentItem:(NSObject <ICPaymentItem> *)paymentItem JSON:(NSDictionary *)rawPaymentItem;

- (void)setPaymentProductFields:(ICPaymentProductFields *)fields JSON:(NSArray *)rawFields;

@end
