//
//  GCPaymentProductFieldDisplayHints.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCPaymentProductFieldDisplayHints.h"

@implementation GCPaymentProductFieldDisplayHints

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.formElement = [[GCFormElement alloc] init];
        self.tooltip = [[GCTooltip alloc] init];
    }
    return self;
}

@end
