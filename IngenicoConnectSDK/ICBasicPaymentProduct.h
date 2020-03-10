//
//  ICBasicPaymentProduct.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import  "ICAccountsOnFile.h"
#import  "ICAccountOnFile.h"
#import  "ICPaymentItemDisplayHints.h"
#import  "ICPaymentItem.h"
#import  "ICBasicPaymentItem.h"
#import  "ICPaymentProduct302SpecificData.h"
#import  "ICPaymentProduct320SpecificData.h"
#import  "ICPaymentProduct863SpecificData.h"

@interface ICBasicPaymentProduct : NSObject <ICBasicPaymentItem>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) ICPaymentItemDisplayHints *displayHints;
@property (strong, nonatomic) ICAccountsOnFile *accountsOnFile;
@property (nonatomic) BOOL allowsTokenization;
@property (nonatomic) BOOL allowsRecurring;
@property (nonatomic) BOOL autoTokenized;

@property (nonatomic) NSString *paymentMethod;
@property (nonatomic) NSString *paymentProductGroup;

@property (strong, nonatomic) ICPaymentProduct302SpecificData *paymentProduct302SpecificData;
@property (strong, nonatomic) ICPaymentProduct320SpecificData *paymentProduct320SpecificData;
@property (strong, nonatomic) ICPaymentProduct863SpecificData *paymentProduct863SpecificData;

- (ICAccountOnFile *)accountOnFileWithIdentifier:(NSString *)accountOnFileIdentifier;
- (void)setStringFormatter:(ICStringFormatter *)stringFormatter;

@end
