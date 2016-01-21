//
//  GCValidatorLuhn.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCValidatorLuhn.h"
#import "GCValidationErrorLuhn.h"

@implementation GCValidatorLuhn

- (void)validate:(NSString *)value
{
    [super validate:value];
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
        GCValidationErrorLuhn *error = [[GCValidationErrorLuhn alloc] init];
        [self.errors addObject:error];
    }
}

@end
