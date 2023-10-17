//
//  ICPaymentProduct.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICBasicPaymentProduct.h"
#import  "ICPaymentProductFields.h"
#import  "ICPaymentProductField.h"

@interface ICPaymentProduct : ICBasicPaymentProduct <ICPaymentItem>

@property (strong, nonatomic) ICPaymentProductFields *fields;
@property (nonatomic) NSString *fieldsWarning;

- (ICPaymentProductField *)paymentProductFieldWithId:(NSString *)paymentProductFieldId;

@end
