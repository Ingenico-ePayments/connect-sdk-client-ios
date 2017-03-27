//
//  ICBasicPaymentProductConverter.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <IngenicoConnectSDK/ICBasicPaymentProduct.h>
#import <IngenicoConnectSDK/ICAssetManager.h>
#import <IngenicoConnectSDK/ICStringFormatter.h>
#import <IngenicoConnectSDK/ICBasicPaymentItemConverter.h>

@interface ICBasicPaymentProductConverter : ICBasicPaymentItemConverter

- (ICBasicPaymentProduct *)basicPaymentProductFromJSON:(NSDictionary *)rawBasicProduct;
- (void)setBasicPaymentProduct:(ICBasicPaymentProduct *)basicProduct JSON:(NSDictionary *)rawBasicProduct;

@end
