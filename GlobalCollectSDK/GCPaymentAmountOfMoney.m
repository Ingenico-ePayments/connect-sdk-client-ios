//
//  GCPaymentAmountOfMoney.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 02/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import "GCPaymentAmountOfMoney.h"
#import "GCSDKConstants.h"

@implementation GCPaymentAmountOfMoney {

}

- (instancetype)initWithTotalAmount:(long)totalAmount currencyCode:(NSString *)currencyCode {
    if ([kGCCurrencyCodes rangeOfString:currencyCode].location == NSNotFound) {
        [NSException raise:@"Invalid currency code" format:@"Currency code %@ is invalid", currencyCode];
    }

    self = [super init];
    if (self) {
        _totalAmount = totalAmount;
        _currencyCode = currencyCode;
    }

    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%ld-%@", (long) self.totalAmount, self.currencyCode];
}

@end
