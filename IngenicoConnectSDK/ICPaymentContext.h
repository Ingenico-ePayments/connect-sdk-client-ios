//
//  ICPaymentContext.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICPaymentAmountOfMoney;

@interface ICPaymentContext : NSObject

@property (strong, nonatomic) ICPaymentAmountOfMoney *amountOfMoney;
@property (nonatomic, readonly) BOOL isRecurring;
@property (strong, nonatomic, readonly) NSString *countryCode;
@property (strong, nonatomic) NSString *locale;

- (instancetype)initWithAmountOfMoney:(ICPaymentAmountOfMoney *)amountOfMoney isRecurring:(BOOL)isRecurring countryCode:(NSString *)countryCode;


@end
