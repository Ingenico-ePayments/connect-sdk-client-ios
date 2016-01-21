//
//  GCPaymentProductFields.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCPaymentProductFields.h"
#import "GCPaymentProductField.h"

@implementation GCPaymentProductFields

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.paymentProductFields = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)sort
{
    [self.paymentProductFields sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        GCPaymentProductField *field1 = (GCPaymentProductField *)obj1;
        GCPaymentProductField *field2 = (GCPaymentProductField *)obj2;
        if (field1.displayHints.displayOrder > field2.displayHints.displayOrder) {
            return NSOrderedDescending;
        }
        if (field1.displayHints.displayOrder < field2.displayHints.displayOrder) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
}

@end
