//
//  ICBasicPaymentProductConverter.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import  "ICBasicPaymentProduct.h"
#import  "ICAssetManager.h"
#import  "ICStringFormatter.h"
#import  "ICBasicPaymentItemConverter.h"

@interface ICBasicPaymentProductConverter : ICBasicPaymentItemConverter

- (ICBasicPaymentProduct *)basicPaymentProductFromJSON:(NSDictionary *)rawBasicProduct;
- (void)setBasicPaymentProduct:(ICBasicPaymentProduct *)basicProduct JSON:(NSDictionary *)rawBasicProduct;

@end
