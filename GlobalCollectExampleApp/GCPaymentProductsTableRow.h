//
//  GCPaymentProductsTableRow.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 10/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCPaymentProductsTableRow : NSObject

@property (strong, nonatomic) NSString *name;
@property (nonatomic) NSString *accountOnFileIdentifier;
@property (nonatomic) NSString *paymentProductIdentifier;
@property (strong, nonatomic) UIImage *logo;

@end
