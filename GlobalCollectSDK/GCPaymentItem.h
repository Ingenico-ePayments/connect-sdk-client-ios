//
//  GCPaymentItem.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 18/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCBasicPaymentItem.h"

@class GCPaymentItemDisplayHints;
@class GCAccountsOnFile;
@class GCPaymentProductFields;
@class GCPaymentProductField;

@protocol GCPaymentItem <NSObject, GCBasicPaymentItem>

@property (strong, nonatomic) GCPaymentProductFields *fields;

- (GCPaymentProductField *)paymentProductFieldWithId:(NSString *)paymentProductFieldId;

@end
