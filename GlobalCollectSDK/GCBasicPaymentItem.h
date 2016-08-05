//
//  GCBasicPaymentItem.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 19/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCAccountsOnFile;
@class GCPaymentItemDisplayHints;

@protocol GCBasicPaymentItem <NSObject>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) GCPaymentItemDisplayHints *displayHints;
@property (strong, nonatomic) GCAccountsOnFile *accountsOnFile;

@end
