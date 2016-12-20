//
//  GCStartViewController.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 01/05/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <PassKit/PassKit.h>
#import <UIKit/UIKit.h>

#import "GCPaymentProductSelectionTarget.h"
#import "GCPaymentRequestTarget.h"
#import "GCContinueShoppingTarget.h"
#import "GCPaymentFinishedTarget.h"

@interface GCStartViewController : UIViewController <GCContinueShoppingTarget, GCPaymentFinishedTarget>

@end
