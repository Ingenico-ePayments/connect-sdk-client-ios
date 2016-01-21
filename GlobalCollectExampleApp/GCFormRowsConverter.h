//
//  GCFormRowsConverter.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 10/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCPaymentRequest.h"
#import "GCViewFactory.h"

@interface GCFormRowsConverter : NSObject

- (NSMutableArray *)formRowsFromPaymentRequest:(GCPaymentRequest *)paymentRequest validation:(BOOL)validation confirmedPaymentProducts:(NSSet *)confirmedPaymentProducts viewFactory:(GCViewFactory *)viewFactory;

@end
