//
//  GCPaymentProductsViewController.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 06/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCPaymentProductSelectionTarget.h"
#import "GCViewFactory.h"
#import "GCBasicPaymentProducts.h"

@class GCPaymentItems;

@interface GCPaymentProductsViewController : UITableViewController

@property (strong, nonatomic) GCViewFactory *viewFactory;
@property (weak, nonatomic) id <GCPaymentProductSelectionTarget> target;
@property (strong, nonatomic) GCPaymentItems *paymentItems;
@property (nonatomic) NSUInteger amount;
@property (strong, nonatomic) NSString *currencyCode;

@end
