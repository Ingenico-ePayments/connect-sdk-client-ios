//
//  ICBasicPaymentProductGroupConverter.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  "ICBasicPaymentItemConverter.h"
#import  "ICPaymentItemConverter.h"

@class ICPaymentProductGroup;
@class ICBasicPaymentProductGroup;

@interface ICBasicPaymentProductGroupConverter : ICBasicPaymentItemConverter

- (ICBasicPaymentProductGroup *)paymentProductGroupFromJSON:(NSDictionary *)rawProductGroup;

@end
