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
#import "GCPaymentProductDisplayHints.h"

@interface GCBasicPaymentProduct : NSObject

@property (nonatomic) BOOL allowsTokenization;
@property (nonatomic) BOOL allowsRecurring;
@property (nonatomic) BOOL autoTokenized;
@property (strong, nonatomic) GCPaymentProductDisplayHints *displayHints;
@property (nonatomic) NSString *identifier;
@property (strong, nonatomic) GCAccountsOnFile *accountsOnFile;

- (GCAccountOnFile *)accountOnFileWithIdentifier:(NSString *)accountOnFileIdentifier;
- (void)setStringFormatter:(GCStringFormatter *)stringFormatter;

@end
