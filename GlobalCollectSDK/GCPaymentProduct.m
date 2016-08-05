//
//  GCPaymentProduct.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 03/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCPaymentProduct.h"

@implementation GCPaymentProduct

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.fields = [[GCPaymentProductFields alloc] init];
    }
    return self;
}

- (GCPaymentProductField *)paymentProductFieldWithId:(NSString *)paymentProductFieldId
{
    for (GCPaymentProductField *field in self.fields.paymentProductFields) {
        if ([field.identifier isEqualToString:paymentProductFieldId] == YES) {
            return field;
        }
    }
    return nil;
}

@end
