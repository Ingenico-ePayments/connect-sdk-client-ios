//
//  GCPaymentAmountOfMoney.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 02/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCPaymentAmountOfMoney : NSObject

@property (nonatomic, readonly) long totalAmount;
@property (strong, nonatomic, readonly) NSString *currencyCode;

- (instancetype)initWithTotalAmount:(long)totalAmount currencyCode:(NSString *)currencyCode;

- (NSString *)description;

@end
