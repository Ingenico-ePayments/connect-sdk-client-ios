//
//  GCValidatorLength.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCValidatorLength.h"
#import "GCValidationErrorLength.h"

@implementation GCValidatorLength

- (void)validate:(NSString *)value
{
    [super validate:value];
    GCValidationErrorLength *error = [[GCValidationErrorLength alloc] init];
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
