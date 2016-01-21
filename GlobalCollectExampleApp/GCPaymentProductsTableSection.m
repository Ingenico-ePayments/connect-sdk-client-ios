//
//  GCPaymentProductsTableSection.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 06/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCPaymentProductsTableSection.h"

@implementation GCPaymentProductsTableSection

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.rows = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
