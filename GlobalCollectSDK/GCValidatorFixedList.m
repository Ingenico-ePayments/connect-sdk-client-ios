//
//  GCValidatorFixedList.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCValidatorFixedList.h"
#import "GCValidationErrorFixedList.h"

@implementation GCValidatorFixedList

- (instancetype) initWithAllowedValues:(NSArray *)allowedValues
{
    self = [super init];
    if (self != nil) {
        _allowedValues = allowedValues;
    }
    return self;
}

- (void)validate:(NSString *)value
{
    [super validate:value];
    for (NSString *allowedValue in self.allowedValues) {
        if ([allowedValue isEqualToString:value] == YES) {
            return;
        }
    }
    GCValidationErrorFixedList *error = [[GCValidationErrorFixedList alloc] init];
    [self.errors addObject:error];
}

@end
