//
//  GCBasicPaymentProductGroup.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 20/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCBasicPaymentItem.h"

@class GCStringFormatter;

@interface GCBasicPaymentProductGroup : NSObject <GCBasicPaymentItem>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) GCPaymentItemDisplayHints *displayHints;
@property (strong, nonatomic) GCAccountsOnFile *accountsOnFile;

- (void)setStringFormatter:(GCStringFormatter *)stringFormatter;

@end
