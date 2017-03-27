//
//  ICPaymentAmountOfMoney.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICPaymentAmountOfMoney : NSObject

@property (nonatomic, readonly) long totalAmount;
@property (strong, nonatomic, readonly) NSString *currencyCode;

- (instancetype)initWithTotalAmount:(long)totalAmount currencyCode:(NSString *)currencyCode;

- (NSString *)description;

@end
