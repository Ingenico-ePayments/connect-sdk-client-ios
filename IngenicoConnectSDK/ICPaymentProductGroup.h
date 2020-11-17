//
//  ICPaymentProductGroup.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  "ICPaymentItem.h"

@class ICStringFormatter;
@class ICAccountOnFile;
@class ICPaymentProductField;

@interface ICPaymentProductGroup : NSObject <ICPaymentItem>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) ICPaymentItemDisplayHints *displayHints;
@property (strong, nonatomic) ICAccountsOnFile *accountsOnFile;
@property (nonatomic, strong) NSString *acquirerCountry;
@property (nonatomic) BOOL allowsTokenization;
@property (nonatomic) BOOL allowsRecurring;
@property (nonatomic) BOOL autoTokenized;
@property (strong, nonatomic) ICPaymentProductFields *fields;

- (ICAccountOnFile *)accountOnFileWithIdentifier:(NSString *)accountOnFileIdentifier;
- (void)setStringFormatter:(ICStringFormatter *)stringFormatter;
- (ICPaymentProductField *)paymentProductFieldWithId:(NSString *)paymentProductFieldId;

@end
