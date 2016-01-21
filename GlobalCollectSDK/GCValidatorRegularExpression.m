//
//  GCValidatorRegularExpression.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCValidatorRegularExpression.h"
#import "GCValidationErrorRegularExpression.h"

@implementation GCValidatorRegularExpression

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
        GCValidationErrorRegularExpression *error = [[GCValidationErrorRegularExpression alloc] init];
        [self.errors addObject:error];
    }
}

@end
