//
//  GCPaymentProductGroupConverter.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 20/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCPaymentItemConverter.h"

@class GCPaymentProductGroup;

@interface GCPaymentProductGroupConverter : GCPaymentItemConverter

- (GCPaymentProductGroup *)paymentProductGroupFromJSON:(NSDictionary *)rawProductGroup;

@end
