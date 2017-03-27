//
//  ICBasicPaymentProducts.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <IngenicoConnectSDK/ICBasicPaymentProduct.h>

@interface ICBasicPaymentProducts : NSObject

@property (strong, nonatomic) NSMutableArray *paymentProducts;

- (BOOL)hasAccountsOnFile;
- (NSArray *)accountsOnFile;
- (ICBasicPaymentProduct *)paymentProductWithIdentifier:(NSString *)paymentProductIdentifier;
- (void)sort;
- (void)setStringFormatter:(ICStringFormatter *)stringFormatter;

@end
