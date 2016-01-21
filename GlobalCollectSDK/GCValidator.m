//
//  GCValidator.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCValidator.h"

@implementation GCValidator

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
    [self.errors removeAllObjects];
}

@end
