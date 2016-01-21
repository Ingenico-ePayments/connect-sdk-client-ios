//
//  GCPaymentProductsTableSection.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 06/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCPaymentType.h"

@interface GCPaymentProductsTableSection : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSMutableArray *rows;
@property (nonatomic) GCPaymentType type;

@end
