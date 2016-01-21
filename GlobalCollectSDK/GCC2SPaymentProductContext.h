//
//  GCC2SPaymentProductContext.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 03/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCC2SPaymentProductContext : NSObject

@property (nonatomic, readonly) long totalAmount;
@property (nonatomic, readonly) BOOL isRecurring;
@property (strong, nonatomic, readonly) NSString *currencyCode;
@property (strong, nonatomic, readonly) NSString *countryCode;

- (instancetype)initWithTotalAmount:(long)totalAmount countryCode:(NSString *)countryCode currencyCode:(NSString *)currencyCode isRecurring:(BOOL)isRecurring;

@end
