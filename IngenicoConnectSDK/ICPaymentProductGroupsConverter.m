//
//  ICPaymentProductGroupsConverter.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICPaymentProductGroupsConverter.h"
#import  "ICBasicPaymentProductGroups.h"
#import  "ICBasicPaymentProductGroupConverter.h"

@implementation ICPaymentProductGroupsConverter

- (ICBasicPaymentProductGroups *)paymentProductGroupsFromJSON:(NSArray *)rawProductGroups {
    ICBasicPaymentProductGroups *groups = [ICBasicPaymentProductGroups new];
    ICBasicPaymentProductGroupConverter *converter = [ICBasicPaymentProductGroupConverter new];
    for (NSDictionary *rawProductGroup in rawProductGroups) {
        ICBasicPaymentProductGroup *group = [converter paymentProductGroupFromJSON:rawProductGroup];
        [groups.paymentProductGroups addObject:group];
    }
    [groups sort];
    return groups;
}

@end
