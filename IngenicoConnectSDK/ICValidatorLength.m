//
//  ICValidatorLength.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <IngenicoConnectSDK/ICValidatorLength.h>
#import <IngenicoConnectSDK/ICValidationErrorLength.h>

@implementation ICValidatorLength

- (void)validate:(NSString *)value forPaymentRequest:(ICPaymentRequest *)request
{
    [super validate:value forPaymentRequest:request];
    ICValidationErrorLength *error = [[ICValidationErrorLength alloc] init];
    error.minLength = self.minLength;
    error.maxLength = self.maxLength;
    if (value.length < self.minLength) {
        [self.errors addObject:error];
    }
    if (value.length > self.maxLength) {
        [self.errors addObject:error];
    }
}

@end
