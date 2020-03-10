//
//  ICPaymentProductField.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICPaymentProductField.h"
#import  "ICValidator.h"
#import  "ICValidationErrorIsRequired.h"
#import  "ICValidationErrorInteger.h"
#import  "ICValidationErrorNumericString.h"

@interface ICPaymentProductField ()

@property (strong, nonatomic) NSNumberFormatter *numberFormatter;
@property (strong, nonatomic) NSRegularExpression *numericStringCheck;

@end

@implementation ICPaymentProductField

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.dataRestrictions = [[ICDataRestrictions alloc] init];
        self.displayHints = [[ICPaymentProductFieldDisplayHints alloc] init];
        self.errors = [[NSMutableArray alloc] init];
        self.numericStringCheck = [[NSRegularExpression alloc] initWithPattern:@"^\\d+$" options:0 error:nil];
        self.numberFormatter = [[NSNumberFormatter alloc] init];
        self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    return self;
}

- (void)validateValue:(NSString *)value
{
    NSLog(@"validateValue: is deprecated! please use validateValue:forPaymentRequest: instead");
    [self validateValue:value forPaymentRequest:nil];
}

- (void)validateValue:(NSString *)value forPaymentRequest:(ICPaymentRequest *)request
{
    [self.errors removeAllObjects];
    if (self.dataRestrictions.isRequired == YES && [value isEqualToString:@""] == YES) {
        ICValidationErrorIsRequired *error = [[ICValidationErrorIsRequired alloc] init];
        [self.errors addObject:error];
    } else if (self.dataRestrictions.isRequired == YES || [value isEqualToString:@""] == NO || self.dataRestrictions.validators.containsSomeTimesRequiredValidator) {
        for (ICValidator *rule in self.dataRestrictions.validators.validators) {
            [rule validate:value forPaymentRequest:request];
            [self.errors addObjectsFromArray:rule.errors];
        }
        switch (self.type) {
            case ICExpirationDate:
                break;
            case ICInteger: {
                NSNumber *number = [self.numberFormatter numberFromString:value];
                if (number == nil) {
                    ICValidationErrorInteger *error = [[ICValidationErrorInteger alloc] init];
                    [self.errors addObject:error];
                }
                break;
            }
            case ICNumericString: {
                if ([self.numericStringCheck numberOfMatchesInString:value options:0 range:NSMakeRange(0, value.length)] != 1) {
                    ICValidationErrorNumericString *error = [[ICValidationErrorNumericString alloc] init];
                    [self.errors addObject:error];
                }
                break;
            }
            case ICString:
                break;
            case ICBooleanString:
                break;
            case ICDateString:
                break;
            default:
                [NSException raise:@"Invalid type" format:@"Type %u is invalid", self.type];
                break;
        }
    }
}

@end
