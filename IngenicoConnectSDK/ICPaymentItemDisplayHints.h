//
//  ICPaymentItemDisplayHints.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ICPaymentItemDisplayHints : NSObject

@property (nonatomic) NSUInteger displayOrder;
@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) NSString *logoPath;
@property (strong, nonatomic) UIImage *logoImage;

@end
