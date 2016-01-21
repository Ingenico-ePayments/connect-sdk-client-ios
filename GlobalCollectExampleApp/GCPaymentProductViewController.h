//
//  GCPaymentProductViewController.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 06/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCViewFactory.h"
#import "GCPaymentProduct.h"
#import "GCAccountOnFile.h"
#import "GCPaymentRequestTarget.h"
#import "GCSession.h"

@interface GCPaymentProductViewController : UITableViewController

@property (weak, nonatomic) id <GCPaymentRequestTarget> paymentRequestTarget;
@property (strong, nonatomic) GCViewFactory *viewFactory;
@property (nonatomic) GCPaymentProduct *paymentProduct;
@property (strong, nonatomic) GCAccountOnFile *accountOnFile;
@property (strong, nonatomic) GCC2SPaymentProductContext *context;
@property (nonatomic) NSUInteger amount;
@property (strong, nonatomic) GCSession *session;

@end
