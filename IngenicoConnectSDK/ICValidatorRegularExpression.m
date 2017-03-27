//
//  ICValidatorRegularExpression.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <IngenicoConnectSDK/ICValidatorRegularExpression.h>
#import <IngenicoConnectSDK/ICValidationErrorRegularExpression.h>

@implementation ICValidatorRegularExpression

- (instancetype)initWithRegularExpression:(NSRegularExpression *)regularExpression
{
    self = [super init];
    if (self != nil) {
        _regularExpression = regularExpression;
    }
    return self;
}

- (void)validate:(NSString *)value
{
    [super validate:value];
    NSInteger numberOfMatches = [self.regularExpression numberOfMatchesInString:value options:0 range:NSMakeRange(0, value.length)];
    if (numberOfMatches != 1) {
        ICValidationErrorRegularExpression *error = [[ICValidationErrorRegularExpression alloc] init];
        [self.errors addObject:error];
    }
}

@end
