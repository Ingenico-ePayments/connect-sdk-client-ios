//
//  ICBasicPaymentItem.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICAccountsOnFile;
@class ICPaymentItemDisplayHints;

@protocol ICBasicPaymentItem <NSObject>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) ICPaymentItemDisplayHints *displayHints;
@property (strong, nonatomic) ICAccountsOnFile *accountsOnFile;
@property (strong, nonatomic) NSString *acquirerCountry;

@end
