//
//  GCPaymentContextConverter.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 02/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCPaymentContext;


@interface GCPaymentContextConverter : NSObject

- (NSDictionary *)JSONFromPaymentProductContext:(GCPaymentContext *)paymentProductContext partialCreditCardNumber:(NSString *)partialCreditCardNumber;
- (NSDictionary *)JSONFromPartialCreditCardNumber:(NSString *)partialCreditCardNumber;

@end
