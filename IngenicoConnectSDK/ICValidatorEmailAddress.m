//
//  ICValidatorEmailAddress.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <IngenicoConnectSDK/ICValidatorEmailAddress.h>
#import <IngenicoConnectSDK/ICValidationErrorEmailAddress.h>

@interface ICValidatorEmailAddress ()

@property (strong, nonatomic) NSRegularExpression *expression;

@end

@implementation ICValidatorEmailAddress

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        NSError *error = nil;
        NSString *regex = @"^[^@\\.]+(\\.[^@\\.]+)*@([^@\\.]+\\.)*[^@\\.]+\\.[^@\\.][^@\\.]+$";
        self.expression = [[NSRegularExpression alloc] initWithPattern:regex options:0 error:&error];
    }
    return self;
}

- (void)validate:(NSString *)value forPaymentRequest:(ICPaymentRequest *)request
{
    [super validate:value forPaymentRequest:request];
    NSInteger numberOfMatches = [self.expression numberOfMatchesInString:value options:0 range:NSMakeRange(0, value.length)];
    if (numberOfMatches != 1) {
        ICValidationErrorEmailAddress *error = [[ICValidationErrorEmailAddress alloc] init];
        [self.errors addObject:error];
    }
}

@end
