//
//  ICPaymentItem.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IngenicoConnectSDK/ICBasicPaymentItem.h>

@class ICPaymentItemDisplayHints;
@class ICAccountsOnFile;
@class ICPaymentProductFields;
@class ICPaymentProductField;

@protocol ICPaymentItem <NSObject, ICBasicPaymentItem>

@property (strong, nonatomic) ICPaymentProductFields *fields;

- (ICPaymentProductField *)paymentProductFieldWithId:(NSString *)paymentProductFieldId;

@end
