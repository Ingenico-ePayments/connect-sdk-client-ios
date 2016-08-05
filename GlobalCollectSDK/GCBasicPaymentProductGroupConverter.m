//
//  GCBasicPaymentProductGroupConverter.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 18/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import "GCBasicPaymentProductGroupConverter.h"
#import "GCBasicPaymentProductGroup.h"

@implementation GCBasicPaymentProductGroupConverter

- (GCBasicPaymentProductGroup *)paymentProductGroupFromJSON:(NSDictionary *)rawProductGroup {
    GCBasicPaymentProductGroup *paymentProductGroup = [GCBasicPaymentProductGroup new];
    [super setBasicPaymentItem:paymentProductGroup JSON:rawProductGroup];
    return paymentProductGroup;
}

@end
