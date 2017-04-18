//
//  ICValidator.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <IngenicoConnectSDK/ICValidator.h>
#import <IngenicoConnectSDK/ICPaymentRequest.h>

@implementation ICValidator

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.errors = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)validate:(NSString *)value
{
    NSLog(@"validate: is deprecated! please use validate:forPaymentRequest: instead");
    [self validate:value forPaymentRequest:nil];
}

- (void)validate:(NSString *)value forPaymentRequest:(ICPaymentRequest *)request
{
    [self.errors removeAllObjects];
}

@end
