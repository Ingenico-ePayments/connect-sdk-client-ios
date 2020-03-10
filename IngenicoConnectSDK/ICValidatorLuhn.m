//
//  ICValidatorLuhn.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICValidatorLuhn.h"
#import  "ICValidationErrorLuhn.h"

@implementation ICValidatorLuhn

- (void)validate:(NSString *)value forPaymentRequest:(ICPaymentRequest *)request
{
    [super validate:value forPaymentRequest:request];
    NSInteger evenSum = 0;
    NSInteger oddSum = 0;
    NSInteger digit;
    for (int i = 1; i <= value.length; ++i) {
        unsigned long j = value.length - i;
        digit = [[NSString stringWithFormat:@"%C", [value characterAtIndex:j]] integerValue];
        if (i % 2 == 1) {
            evenSum += digit;
        } else {
            digit = digit * 2;
            digit = (digit % 10) + (digit / 10);
            oddSum += digit;
        }
    }
    NSInteger total = evenSum + oddSum;
    if (total % 10 != 0) {
        ICValidationErrorLuhn *error = [[ICValidationErrorLuhn alloc] init];
        [self.errors addObject:error];
    }
}

@end
