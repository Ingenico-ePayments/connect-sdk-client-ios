//
//  GCPaymentProductFieldDisplayHints.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCPreferredInputType.h"
#import "GCFormElement.h"
#import "GCToolTip.h"

@interface GCPaymentProductFieldDisplayHints : NSObject

@property (nonatomic) BOOL alwaysShow;
@property (nonatomic) NSInteger displayOrder;
@property (strong, nonatomic) GCFormElement *formElement;
@property (strong, nonatomic) NSString *mask;
@property (nonatomic) BOOL obfuscate;
@property (nonatomic) GCPreferredInputType preferredInputType;
@property (strong, nonatomic) GCTooltip *tooltip;

@end
