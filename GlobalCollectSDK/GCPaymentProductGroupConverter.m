//
//  GCPaymentProductGroupConverter.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 20/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import "GCPaymentProductGroupConverter.h"
#import "GCPaymentProductGroup.h"

@implementation GCPaymentProductGroupConverter {

}

- (GCPaymentProductGroup *)paymentProductGroupFromJSON:(NSDictionary *)rawProductGroup {
    GCPaymentProductGroup *paymentProductGroup = [GCPaymentProductGroup new];
    [super setPaymentItem:paymentProductGroup JSON:rawProductGroup];
    return paymentProductGroup;
}

@end
