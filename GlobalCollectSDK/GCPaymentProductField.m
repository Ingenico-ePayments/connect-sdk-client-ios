//
//  GCPaymentProductField.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCPaymentProductField.h"
#import "GCValidator.h"
#import "GCValidationErrorIsRequired.h"
#import "GCValidationErrorInteger.h"
#import "GCValidationErrorNumericString.h"

@interface GCPaymentProductField ()

@property (strong, nonatomic) NSNumberFormatter *numberFormatter;
@property (strong, nonatomic) NSRegularExpression *numericStringCheck;

@end

@implementation GCPaymentProductField

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.dataRestrictions = [[GCDataRestrictions alloc] init];
        self.displayHints = [[GCPaymentProductFieldDisplayHints alloc] init];
        self.errors = [[NSMutableArray alloc] init];
        self.numericStringCheck = [[NSRegularExpression alloc] initWithPattern:@"^\\d+$" options:0 error:nil];
        self.numberFormatter = [[NSNumberFormatter alloc] init];
        self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    return self;
}

- (void)validateValue:(NSString *)value
{
    [self.errors removeAllObjects];
    if (self.dataRestrictions.isRequired == YES && [value isEqualToString:@""] == YES ) {
        GCValidationErrorIsRequired *error = [[GCValidationErrorIsRequired alloc] init];
        [self.errors addObject:error];
    } else {
        if (self.dataRestrictions.isRequired == YES || [value isEqualToString:@""] == NO) {
            for (GCValidator *rule in self.dataRestrictions.validators.validators) {
                [rule validate:value];
                [self.errors addObjectsFromArray:rule.errors];
            }
            switch (self.type) {
                case GCExpirationDate:
                break;
                case GCInteger: {
                    NSNumber *number = [self.numberFormatter numberFromString:value];
                    if (number == nil) {
                        GCValidationErrorInteger *error = [[GCValidationErrorInteger alloc] init];
                        [self.errors addObject:error];
                    }
                    break;
                }
                case GCNumericString: {
                    if ([self.numericStringCheck numberOfMatchesInString:value options:0 range:NSMakeRange(0, value.length)] != 1) {
                        GCValidationErrorNumericString *error = [[GCValidationErrorNumericString alloc] init];
                        [self.errors addObject:error];
                    }
                    break;
                }
                case GCString:
                break;
                default:
                [NSException raise:@"Invalid type" format:@"Type %u is invalid", self.type];
                break;
            }
        }
    }
}

@end
