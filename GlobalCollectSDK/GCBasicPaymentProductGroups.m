//
//  GCBasicPaymentProductGroups.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 18/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import "GCBasicPaymentProductGroups.h"
#import "GCStringFormatter.h"
#import "GCAccountsOnFile.h"
#import "GCPaymentItemDisplayHints.h"
#import "GCBasicPaymentProductGroup.h"

@interface GCBasicPaymentProductGroups ()

@property (strong, nonatomic) GCStringFormatter *stringFormatter;

@end

@implementation GCBasicPaymentProductGroups

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.paymentProductGroups = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)hasAccountsOnFile
{
    for (GCBasicPaymentProductGroup *productGroup in self.paymentProductGroups) {
        if (productGroup.accountsOnFile.accountsOnFile.count > 0) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)accountsOnFile
{
    NSMutableArray *accountsOnFile = [[NSMutableArray alloc] init];
    for (GCBasicPaymentProductGroup *productGroup in self.paymentProductGroups) {
        [accountsOnFile addObjectsFromArray:productGroup.accountsOnFile.accountsOnFile];
    }
    return accountsOnFile;
}

- (NSString *)logoPathForPaymentProductGroup:(NSString *)paymentProductGroupIdentifier
{
    GCBasicPaymentProductGroup *productGroup = [self paymentProductGroupWithIdentifier:paymentProductGroupIdentifier];
    return productGroup.displayHints.logoPath;
}

- (GCBasicPaymentProductGroup *)paymentProductGroupWithIdentifier:(NSString *)paymentProductGroupIdentifier
{
    for (GCBasicPaymentProductGroup *productGroup in self.paymentProductGroups) {
        if ([productGroup.identifier isEqualToString:paymentProductGroupIdentifier] == YES) {
            return productGroup;
        }
    }
    return nil;
}

- (void)setStringFormatter:(GCStringFormatter *)stringFormatter
{
    for (GCBasicPaymentProductGroup *productGroup in self.paymentProductGroups) {
        [productGroup setStringFormatter:stringFormatter];
    }
}

- (void)sort
{
    [self.paymentProductGroups sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        GCBasicPaymentProductGroup *productGroup1 = (GCBasicPaymentProductGroup *)obj1;
        GCBasicPaymentProductGroup *productGroup2 = (GCBasicPaymentProductGroup *)obj2;

        if (productGroup1.displayHints.displayOrder > productGroup2.displayHints.displayOrder) {
            return NSOrderedDescending;
        }
        if (productGroup1.displayHints.displayOrder < productGroup2.displayHints.displayOrder) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
}

@end
