//
//  ICPaymentProductConverter.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <IngenicoConnectSDK/ICBasicPaymentProductConverter.h>
#import <IngenicoConnectSDK/ICPaymentProduct.h>
#import <IngenicoConnectSDK/ICPaymentItemConverter.h>

@interface ICPaymentProductConverter : ICBasicPaymentProductConverter

- (ICPaymentProduct *)paymentProductFromJSON:(NSDictionary *)rawProduct;

@end
