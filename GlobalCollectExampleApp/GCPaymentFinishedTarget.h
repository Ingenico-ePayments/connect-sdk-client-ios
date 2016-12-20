//
//  GCPaymentFinishedTarget.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 01/11/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#ifndef GCPaymentFinishedTarget_h
#define GCPaymentFinishedTarget_h

@protocol GCPaymentFinishedTarget <NSObject>

- (void)didFinishPayment;

@end

#endif /* GCPaymentFinishedTarget_h */
