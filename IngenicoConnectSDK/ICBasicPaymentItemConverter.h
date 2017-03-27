//
//  ICBasicPaymentItemConverter.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICPaymentProductFields;
@protocol ICBasicPaymentItem;


@interface ICBasicPaymentItemConverter : NSObject

- (void)setBasicPaymentItem:(NSObject <ICBasicPaymentItem> *)paymentItem JSON:(NSDictionary *)rawPaymentItem;

@end
