//
//  ICBasicPaymentProductGroups.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICBasicPaymentProductGroups.h"
#import  "ICStringFormatter.h"
#import  "ICAccountsOnFile.h"
#import  "ICPaymentItemDisplayHints.h"
#import  "ICBasicPaymentProductGroup.h"

@interface ICBasicPaymentProductGroups ()

@property (strong, nonatomic) ICStringFormatter *stringFormatter;

@end

@implementation ICBasicPaymentProductGroups

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
    for (ICBasicPaymentProductGroup *productGroup in self.paymentProductGroups) {
        if (productGroup.accountsOnFile.accountsOnFile.count > 0) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)accountsOnFile
{
    NSMutableArray *accountsOnFile = [[NSMutableArray alloc] init];
    for (ICBasicPaymentProductGroup *productGroup in self.paymentProductGroups) {
        [accountsOnFile addObjectsFromArray:productGroup.accountsOnFile.accountsOnFile];
    }
    return accountsOnFile;
}

- (NSString *)logoPathForPaymentProductGroup:(NSString *)paymentProductGroupIdentifier
{
    ICBasicPaymentProductGroup *productGroup = [self paymentProductGroupWithIdentifier:paymentProductGroupIdentifier];
    return productGroup.displayHints.logoPath;
}

- (ICBasicPaymentProductGroup *)paymentProductGroupWithIdentifier:(NSString *)paymentProductGroupIdentifier
{
    for (ICBasicPaymentProductGroup *productGroup in self.paymentProductGroups) {
        if ([productGroup.identifier isEqualToString:paymentProductGroupIdentifier] == YES) {
            return productGroup;
        }
    }
    return nil;
}

- (void)setStringFormatter:(ICStringFormatter *)stringFormatter
{
    for (ICBasicPaymentProductGroup *productGroup in self.paymentProductGroups) {
        [productGroup setStringFormatter:stringFormatter];
    }
}

- (void)sort
{
    [self.paymentProductGroups sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        ICBasicPaymentProductGroup *productGroup1 = (ICBasicPaymentProductGroup *)obj1;
        ICBasicPaymentProductGroup *productGroup2 = (ICBasicPaymentProductGroup *)obj2;

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
