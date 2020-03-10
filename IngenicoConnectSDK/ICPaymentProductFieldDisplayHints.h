//
//  ICPaymentProductFieldDisplayHints.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import  "ICPreferredInputType.h"
#import  "ICFormElement.h"
#import  "ICToolTip.h"

@interface ICPaymentProductFieldDisplayHints : NSObject

@property (nonatomic) BOOL alwaysShow;
@property (nonatomic) NSInteger displayOrder;
@property (strong, nonatomic) ICFormElement *formElement;
@property (strong, nonatomic) NSString *mask;
@property (nonatomic) BOOL obfuscate;
@property (nonatomic) ICPreferredInputType preferredInputType;
@property (strong, nonatomic) ICTooltip *tooltip;
@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) NSURL *link;

@end
