//
//  ICValidatorBoletoBancarioRequiredness.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 02/03/2017.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICValidatorBoletoBancarioRequiredness.h"
#import  "ICPaymentRequest.h"
#import  "ICValidationErrorIsRequired.h"

@implementation ICValidatorBoletoBancarioRequiredness

- (void)validate:(NSString *)value forPaymentRequest:(ICPaymentRequest *)request {
    [super validate:value forPaymentRequest:request];
    if (request != nil) {
        NSString *fiscalNumber = [request unmaskedValueForField:@"fiscalNumber"];
        if (fiscalNumber != nil) {
            if (fiscalNumber.length == self.fiscalNumberLength && [value isEqualToString:@""]) {
                ICValidationErrorIsRequired *error = [[ICValidationErrorIsRequired alloc] init];
                [self.errors addObject:error];
            }
        }
    }
}

@end
