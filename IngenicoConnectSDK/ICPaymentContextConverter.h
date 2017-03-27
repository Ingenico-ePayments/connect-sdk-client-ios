//
//  ICPaymentContextConverter.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICPaymentContext;


@interface ICPaymentContextConverter : NSObject

- (NSDictionary *)JSONFromPaymentProductContext:(ICPaymentContext *)paymentProductContext partialCreditCardNumber:(NSString *)partialCreditCardNumber;
- (NSDictionary *)JSONFromPartialCreditCardNumber:(NSString *)partialCreditCardNumber;

@end
