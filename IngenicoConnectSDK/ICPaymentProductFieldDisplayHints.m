//
//  ICPaymentProductFieldDisplayHints.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICPaymentProductFieldDisplayHints.h"

@implementation ICPaymentProductFieldDisplayHints

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.formElement = [[ICFormElement alloc] init];
        self.tooltip = [[ICTooltip alloc] init];
    }
    return self;
}

@end
