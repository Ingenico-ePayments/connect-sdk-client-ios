//
//  GCBasicPaymentProduct.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCAccountsOnFile.h"
#import "GCAccountOnFile.h"
#import "GCPaymentItemDisplayHints.h"
#import "GCPaymentItem.h"
#import "GCBasicPaymentItem.h"

@interface GCBasicPaymentProduct : NSObject <GCBasicPaymentItem>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) GCPaymentItemDisplayHints *displayHints;
@property (strong, nonatomic) GCAccountsOnFile *accountsOnFile;
@property (nonatomic) BOOL allowsTokenization;
@property (nonatomic) BOOL allowsRecurring;
@property (nonatomic) BOOL autoTokenized;

@property (nonatomic) NSString *paymentMethod;
@property (nonatomic) NSString *paymentProductGroup;

- (GCAccountOnFile *)accountOnFileWithIdentifier:(NSString *)accountOnFileIdentifier;
- (void)setStringFormatter:(GCStringFormatter *)stringFormatter;

@end
