//
//  ICPaymentProduct.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <IngenicoConnectSDK/ICBasicPaymentProduct.h>
#import <IngenicoConnectSDK/ICPaymentProductFields.h>
#import <IngenicoConnectSDK/ICPaymentProductField.h>

@interface ICPaymentProduct : ICBasicPaymentProduct <ICPaymentItem>

@property (strong, nonatomic) ICPaymentProductFields *fields;

- (ICPaymentProductField *)paymentProductFieldWithId:(NSString *)paymentProductFieldId;

@end
