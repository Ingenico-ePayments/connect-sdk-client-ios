//
//  GCBasicPaymentProductGroups.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 18/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCStringFormatter;
@class GCBasicPaymentProductGroup;

@interface GCBasicPaymentProductGroups : NSObject

@property (nonatomic, strong) NSMutableArray *paymentProductGroups;

- (BOOL)hasAccountsOnFile;
- (NSArray *)accountsOnFile;
- (GCBasicPaymentProductGroup *)paymentProductGroupWithIdentifier:(NSString *)paymentProductGroupIdentifier;
- (void)sort;
- (void)setStringFormatter:(GCStringFormatter *)stringFormatter;

@end
