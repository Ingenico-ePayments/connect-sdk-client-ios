//
//  GCPaymentProductGroupsConverter.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 18/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCBasicPaymentProductGroups;

@interface GCPaymentProductGroupsConverter : NSObject

- (GCBasicPaymentProductGroups *)paymentProductGroupsFromJSON:(NSArray *)rawProductGroups;

@end
