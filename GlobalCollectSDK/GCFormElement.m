//
//  GCFormElement.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 14/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCFormElement.h"

@implementation GCFormElement

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.valueMapping = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
