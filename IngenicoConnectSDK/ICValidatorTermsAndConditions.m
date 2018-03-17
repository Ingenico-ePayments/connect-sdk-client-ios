//
//  ICValidatorTermsAndConditions.m
//  IngenicoConnectSDK
//
//  Created by PharmIT on 09/01/2018.
//  Copyright © 2018 Global Collect Services. All rights reserved.
//

#import "ICValidatorTermsAndConditions.h"
#import "ICValidatorRegularExpression.h"
#import "ICValidationErrorTermsAndConditions.h"
@implementation ICValidatorTermsAndConditions
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)validate:(NSString *)value forPaymentRequest:(ICPaymentRequest *)request
{
    [super validate:value forPaymentRequest:request];
    if (![@"true" isEqualToString:value]) {
        [self.errors addObject:[[ICValidationErrorTermsAndConditions alloc]init]];
    }
}
@end
