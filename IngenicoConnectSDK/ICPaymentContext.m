//
//  ICPaymentContext.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICPaymentContext.h"
#import  "ICSDKConstants.h"
#import  "ICPaymentAmountOfMoney.h"

@implementation ICPaymentContext

- (instancetype)initWithAmountOfMoney:(ICPaymentAmountOfMoney *)amountOfMoney isRecurring:(BOOL)isRecurring countryCode:(NSString *)countryCode {
    if ([kICCountryCodes rangeOfString:countryCode].location == NSNotFound) {
        [NSException raise:@"Invalid country code" format:@"Country code %@ is invalid", countryCode];
    }

    self = [super init];
    if (self) {
        self.amountOfMoney = amountOfMoney;
        _isRecurring = isRecurring;
        _countryCode = countryCode;
    }
    self.forceBasicFlow = YES;
    self.locale = [[[[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode] stringByAppendingString:@"_"] stringByAppendingString:[[NSLocale currentLocale] objectForKey: NSLocaleCountryCode]];

    return self;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@-%@-%@", self.amountOfMoney.description, self.countryCode, self.isRecurring ? @"YES" : @"NO"];
}

@end
