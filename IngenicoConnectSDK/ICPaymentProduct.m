//
//  ICPaymentProduct.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICPaymentProduct.h"

@implementation ICPaymentProduct

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.fields = [[ICPaymentProductFields alloc] init];
    }
    return self;
}

- (ICPaymentProductField *)paymentProductFieldWithId:(NSString *)paymentProductFieldId
{
    for (ICPaymentProductField *field in self.fields.paymentProductFields) {
        if ([field.identifier isEqualToString:paymentProductFieldId] == YES) {
            return field;
        }
    }
    return nil;
}

@end
