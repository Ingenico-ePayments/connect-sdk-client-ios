//
//  GCPaymentContext.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 03/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCPaymentAmountOfMoney;

@interface GCPaymentContext : NSObject

@property (strong, nonatomic) GCPaymentAmountOfMoney *amountOfMoney;
@property (nonatomic, readonly) BOOL isRecurring;
@property (strong, nonatomic, readonly) NSString *countryCode;

- (instancetype)initWithAmountOfMoney:(GCPaymentAmountOfMoney *)amountOfMoney isRecurring:(BOOL)isRecurring countryCode:(NSString *)countryCode;


@end
