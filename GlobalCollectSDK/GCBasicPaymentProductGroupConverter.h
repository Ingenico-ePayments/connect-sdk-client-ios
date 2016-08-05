//
//  GCBasicPaymentProductGroupConverter.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 18/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCBasicPaymentItemConverter.h"
#import "GCPaymentItemConverter.h"

@class GCPaymentProductGroup;
@class GCBasicPaymentProductGroup;

@interface GCBasicPaymentProductGroupConverter : GCBasicPaymentItemConverter

- (GCBasicPaymentProductGroup *)paymentProductGroupFromJSON:(NSDictionary *)rawProductGroup;

@end
