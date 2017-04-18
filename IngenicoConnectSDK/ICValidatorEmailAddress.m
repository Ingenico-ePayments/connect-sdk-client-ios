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
        NSString *qtext = @"[^\\x0d\\x22\\x5c\\x80-\\xff]";
        NSString *dtext = @"[^\\x0d\\x5b-\\x5d\\x80-\\xff]";
        NSString *atom = @"[^\\x00-\\x20\\x22\\x28\\x29\\x2c\\x2e\\x3a-\\x3c\\x3e\\x40\\x5b-\\x5d\\x7f-\\xff]+";
        NSString *quoted_pair = @"\\x5c[\\x00-\\x7f]";
        NSString *domain_literal = [NSString stringWithFormat:@"\\x5b(%@|%@)*\\x5d", dtext, quoted_pair];
        NSString *quoted_string = [NSString stringWithFormat:@"\\x22(%@|%@)*\\x22", qtext, quoted_pair];
        NSString *domain_ref = atom;
        NSString *sub_domain = [NSString stringWithFormat:@"(%@|%@)", domain_ref, domain_literal];
        NSString *word = [NSString stringWithFormat:@"(%@|%@)", atom, quoted_string];
        NSString *domain = [NSString stringWithFormat:@"%@(\\x2e%@)*", sub_domain, sub_domain];
        NSString *local_part = [NSString stringWithFormat:@"%@(\\x2e%@)*", word, word];
        NSString *addr_spec = [NSString stringWithFormat:@"%@\\x40%@", local_part, domain];
        NSString *complete = [NSString stringWithFormat:@"^%@$", addr_spec];
        self.expression = [[NSRegularExpression alloc] initWithPattern:complete options:0 error:&error];
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
