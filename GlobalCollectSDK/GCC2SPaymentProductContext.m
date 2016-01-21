//
//  GCC2SPaymentProductContext.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 03/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCC2SPaymentProductContext.h"
#import "GCSDKConstants.h"

@implementation GCC2SPaymentProductContext

- (instancetype)initWithTotalAmount:(long)totalAmount countryCode:(NSString *)countryCode currencyCode:(NSString *)currencyCode isRecurring:(BOOL)isRecurring
{
    if ([kGCCountryCodes rangeOfString:countryCode].location == NSNotFound) {
        [NSException raise:@"Invalid country code" format:@"Country code %@ is invalid", countryCode];
    }
    if ([kGCCurrencyCodes rangeOfString:currencyCode].location == NSNotFound) {
        [NSException raise:@"Invalid currency code" format:@"Currency code %@ is invalid", currencyCode];
    }
    self = [super init];
    if (self != nil) {
        _totalAmount = totalAmount;
        _countryCode = countryCode;
        _currencyCode = currencyCode;
        _isRecurring = isRecurring;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%ld-%@-%@-%@", (long) self.totalAmount, self.countryCode, self.currencyCode, self.isRecurring ? @"YES" : @"NO"];
}

@end
