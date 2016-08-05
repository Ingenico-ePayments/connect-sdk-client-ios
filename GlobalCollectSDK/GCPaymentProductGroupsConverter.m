//
//  GCPaymentProductGroupsConverter.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 18/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import "GCPaymentProductGroupsConverter.h"
#import "GCBasicPaymentProductGroups.h"
#import "GCBasicPaymentProductGroupConverter.h"

@implementation GCPaymentProductGroupsConverter

- (GCBasicPaymentProductGroups *)paymentProductGroupsFromJSON:(NSArray *)rawProductGroups {
    GCBasicPaymentProductGroups *groups = [GCBasicPaymentProductGroups new];
    GCBasicPaymentProductGroupConverter *converter = [GCBasicPaymentProductGroupConverter new];
    for (NSDictionary *rawProductGroup in rawProductGroups) {
        GCPaymentProductGroup *group = [converter paymentProductGroupFromJSON:rawProductGroup];
        [groups.paymentProductGroups addObject:group];
    }
    [groups sort];
    return groups;
}

@end
