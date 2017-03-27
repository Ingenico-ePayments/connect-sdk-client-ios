//
//  ICValidatorFixedList.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <IngenicoConnectSDK/ICValidatorFixedList.h>
#import <IngenicoConnectSDK/ICValidationErrorFixedList.h>

@implementation ICValidatorFixedList

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
    ICValidationErrorFixedList *error = [[ICValidationErrorFixedList alloc] init];
    [self.errors addObject:error];
}

@end
