//
//  ICBasicPaymentProductGroup.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IngenicoConnectSDK/ICBasicPaymentItem.h>
#import <IngenicoConnectSDK/ICAccountOnFile.h>
@class ICStringFormatter;

@interface ICBasicPaymentProductGroup : NSObject <ICBasicPaymentItem>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) ICPaymentItemDisplayHints *displayHints;
@property (nonatomic, strong) ICAccountsOnFile *accountsOnFile;


- (void)setStringFormatter:(ICStringFormatter *)stringFormatter;
- (ICAccountOnFile *)accountOnFileWithIdentifier:(NSString *)accountOnFileIdentifier;

@end
