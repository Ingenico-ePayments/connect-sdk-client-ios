//
//  ICPaymentProductGroupConverter.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  "ICPaymentItemConverter.h"

@class ICPaymentProductGroup;

@interface ICPaymentProductGroupConverter : ICPaymentItemConverter

- (ICPaymentProductGroup *)paymentProductGroupFromJSON:(NSDictionary *)rawProductGroup;

@end
