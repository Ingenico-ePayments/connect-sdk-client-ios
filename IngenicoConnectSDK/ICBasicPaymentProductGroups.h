//
//  ICBasicPaymentProductGroups.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICStringFormatter;
@class ICBasicPaymentProductGroup;

@interface ICBasicPaymentProductGroups : NSObject

@property (nonatomic, strong) NSMutableArray *paymentProductGroups;

- (BOOL)hasAccountsOnFile;
- (NSArray *)accountsOnFile;
- (ICBasicPaymentProductGroup *)paymentProductGroupWithIdentifier:(NSString *)paymentProductGroupIdentifier;
- (void)sort;
- (void)setStringFormatter:(ICStringFormatter *)stringFormatter;

@end
