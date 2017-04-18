//
//  ICValidatorRange.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <IngenicoConnectSDK/ICValidatorRange.h>
#import <IngenicoConnectSDK/ICValidationErrorRange.h>

@interface ICValidatorRange ()

@property (strong, nonatomic) NSNumberFormatter *formatter;

@end

@implementation ICValidatorRange

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.formatter = [[NSNumberFormatter alloc] init];
        self.formatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    return self;
}

- (void)validate:(NSString *)value forPaymentRequest:(ICPaymentRequest *)request
{
    [super validate:value forPaymentRequest:request];
    NSNumber *number = [self.formatter numberFromString:value];
    NSInteger valueAsInteger = [number integerValue];
    ICValidationErrorRange *error = [[ICValidationErrorRange alloc] init];
    error.minValue = self.minValue;
    error.maxValue = self.maxValue;
    if (number == nil) {
        [self.errors addObject:error];
    } else if (valueAsInteger < self.minValue) {
        [self.errors addObject:error];
    } else if (valueAsInteger > self.maxValue) {
        [self.errors addObject:error];
    }
}

@end
