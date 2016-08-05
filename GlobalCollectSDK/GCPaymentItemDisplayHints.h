//
//  GCPaymentItemDisplayHints.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 14/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GCPaymentItemDisplayHints : NSObject

@property (nonatomic) NSUInteger displayOrder;
@property (strong, nonatomic) NSString *logoPath;
@property (strong, nonatomic) UIImage *logoImage;

@end
