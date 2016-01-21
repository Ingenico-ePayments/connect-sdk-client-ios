//
//  GCPaymentRequestTarget.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 02/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCPaymentRequest.h"

@protocol GCPaymentRequestTarget <NSObject>

- (void)didSubmitPaymentRequest:(GCPaymentRequest *)paymentRequest;
- (void)didCancelPaymentRequest;

@end
