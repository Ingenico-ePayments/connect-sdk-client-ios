//
//  ICBasicPaymentProductsConverter.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <IngenicoConnectSDK/ICBasicPaymentProducts.h>
#import <IngenicoConnectSDK/ICAssetManager.h>
#import <IngenicoConnectSDK/ICStringFormatter.h>

@interface ICBasicPaymentProductsConverter : NSObject

- (ICBasicPaymentProducts *)paymentProductsFromJSON:(NSArray *)rawProducts;

@end
