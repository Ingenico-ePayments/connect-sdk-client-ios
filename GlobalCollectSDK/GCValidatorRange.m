//
//  GCValidatorRange.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCValidatorRange.h"
#import "GCValidationErrorRange.h"

@interface GCValidatorRange ()

@property (strong, nonatomic) NSNumberFormatter *formatter;

@end

@implementation GCValidatorRange

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.formatter = [[NSNumberFormatter alloc] init];
        self.formatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    return self;
}

- (void)validate:(NSString *)value
{
    [super validate:value];
    NSNumber *number = [self.formatter numberFromString:value];
    NSInteger valueAsInteger = [number integerValue];
    GCValidationErrorRange *error = [[GCValidationErrorRange alloc] init];
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
