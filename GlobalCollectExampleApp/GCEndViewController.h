//
//  GCEndViewController.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 02/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCContinueShoppingTarget.h"
#import "GCViewFactory.h"

@interface GCEndViewController : UIViewController

@property (weak, nonatomic) id <GCContinueShoppingTarget> target;
@property (strong, nonatomic) GCViewFactory *viewFactory;

@end
