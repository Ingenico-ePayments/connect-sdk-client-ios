//
//  ICBasicPaymentProduct.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <IngenicoConnectSDK/ICAccountsOnFile.h>
#import <IngenicoConnectSDK/ICAccountOnFile.h>
#import <IngenicoConnectSDK/ICPaymentItemDisplayHints.h>
#import <IngenicoConnectSDK/ICPaymentItem.h>
#import <IngenicoConnectSDK/ICBasicPaymentItem.h>

@interface ICBasicPaymentProduct : NSObject <ICBasicPaymentItem>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) ICPaymentItemDisplayHints *displayHints;
@property (strong, nonatomic) ICAccountsOnFile *accountsOnFile;
@property (nonatomic) BOOL allowsTokenization;
@property (nonatomic) BOOL allowsRecurring;
@property (nonatomic) BOOL autoTokenized;

@property (nonatomic) NSString *paymentMethod;
@property (nonatomic) NSString *paymentProductGroup;

- (ICAccountOnFile *)accountOnFileWithIdentifier:(NSString *)accountOnFileIdentifier;
- (void)setStringFormatter:(ICStringFormatter *)stringFormatter;

@end
