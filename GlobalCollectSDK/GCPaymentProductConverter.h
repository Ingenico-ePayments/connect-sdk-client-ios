//
//  GCPaymentProductConverter.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 03/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCBasicPaymentProductConverter.h"
#import "GCPaymentProduct.h"
#import "GCPaymentItemConverter.h"

@interface GCPaymentProductConverter : GCBasicPaymentProductConverter

- (GCPaymentProduct *)paymentProductFromJSON:(NSDictionary *)rawProduct;

@end
