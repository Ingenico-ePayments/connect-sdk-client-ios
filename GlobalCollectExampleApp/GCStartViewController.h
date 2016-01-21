//
//  GCStartViewController.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 01/05/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCPaymentProductSelectionTarget.h"
#import "GCPaymentRequestTarget.h"
#import "GCContinueShoppingTarget.h"

@interface GCStartViewController : UIViewController <GCPaymentProductSelectionTarget, GCPaymentRequestTarget, GCContinueShoppingTarget>

@end
