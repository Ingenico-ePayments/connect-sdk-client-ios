//
//  GCPaymentContext.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 03/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCPaymentContext.h"
#import "GCSDKConstants.h"
#import "GCPaymentAmountOfMoney.h"

@implementation GCPaymentContext

- (instancetype)initWithAmountOfMoney:(GCPaymentAmountOfMoney *)amountOfMoney isRecurring:(BOOL)isRecurring countryCode:(NSString *)countryCode {
    if ([kGCCountryCodes rangeOfString:countryCode].location == NSNotFound) {
        [NSException raise:@"Invalid country code" format:@"Country code %@ is invalid", countryCode];
    }

    self = [super init];
    if (self) {
        self.amountOfMoney = amountOfMoney;
        _isRecurring = isRecurring;
        _countryCode = countryCode;
    }

    return self;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@-%@-%@", self.amountOfMoney.description, self.countryCode, self.isRecurring ? @"YES" : @"NO"];
}

@end
