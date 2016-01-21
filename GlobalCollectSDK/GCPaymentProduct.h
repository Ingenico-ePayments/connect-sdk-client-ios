//
//  GCPaymentProduct.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 03/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCBasicPaymentProduct.h"
#import "GCPaymentProductFields.h"
#import "GCPaymentProductField.h"

@interface GCPaymentProduct : GCBasicPaymentProduct

@property (strong, nonatomic) GCPaymentProductFields *fields;

- (GCPaymentProductField *)paymentProductFieldWithId:(NSString *)paymentProductFieldId;

@end
