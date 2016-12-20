//
//  GCPaymentProductSelectionDelegate.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 01/11/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PassKit/PassKit.h>
#import "GCPaymentProductSelectionTarget.h"
#import "GCPaymentRequestTarget.h"
#import "GCSession.h"
#import "GCSDKConstants.h"
#import "GCAppConstants.h"
#import "GCPaymentProductViewController.h"
#import "GCPaymentFinishedTarget.h"


@interface GCPaymentProductsViewControllerTarget : NSObject <GCPaymentProductSelectionTarget, GCPaymentRequestTarget, PKPaymentAuthorizationViewControllerDelegate>

@property (weak, nonatomic) id <GCPaymentFinishedTarget> paymentFinishedTarget;

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController session:(GCSession *)session context:(GCPaymentContext *)context viewFactory:(GCViewFactory *)viewFactory;

@end
