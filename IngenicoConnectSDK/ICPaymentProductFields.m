//
//  ICPaymentProductFields.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICPaymentProductFields.h"
#import  "ICPaymentProductField.h"

@implementation ICPaymentProductFields

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
        ICPaymentProductField *field1 = (ICPaymentProductField *)obj1;
        ICPaymentProductField *field2 = (ICPaymentProductField *)obj2;
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
