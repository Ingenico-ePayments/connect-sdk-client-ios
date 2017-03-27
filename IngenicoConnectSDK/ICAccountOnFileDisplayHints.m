//
//  ICAccountOnFileDisplayHints.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <IngenicoConnectSDK/ICAccountOnFileDisplayHints.h>

@implementation ICAccountOnFileDisplayHints

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.labelTemplate = [[ICLabelTemplate alloc] init];
    }
    return self;
}

@end
