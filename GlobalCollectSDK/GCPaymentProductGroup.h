//
//  GCPaymentProductGroup.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 18/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCPaymentItem.h"

@class GCStringFormatter;
@class GCAccountOnFile;
@class GCPaymentProductField;

@interface GCPaymentProductGroup : NSObject <GCPaymentItem>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) GCPaymentItemDisplayHints *displayHints;
@property (strong, nonatomic) GCAccountsOnFile *accountsOnFile;
@property (nonatomic) BOOL allowsTokenization;
@property (nonatomic) BOOL allowsRecurring;
@property (nonatomic) BOOL autoTokenized;
@property (strong, nonatomic) GCPaymentProductFields *fields;

- (GCAccountOnFile *)accountOnFileWithIdentifier:(NSString *)accountOnFileIdentifier;
- (void)setStringFormatter:(GCStringFormatter *)stringFormatter;
- (GCPaymentProductField *)paymentProductFieldWithId:(NSString *)paymentProductFieldId;

@end
