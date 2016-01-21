//
//  GCPaymentProducts.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCPaymentProducts.h"
#import "GCBasicPaymentProduct.h"

@interface GCPaymentProducts ()

@property (strong, nonatomic) GCStringFormatter *stringFormatter;

@end

@implementation GCPaymentProducts

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.paymentProducts = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)hasAccountsOnFile
{
    for (GCBasicPaymentProduct *product in self.paymentProducts) {
        if (product.accountsOnFile.accountsOnFile.count > 0) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)accountsOnFile
{
    NSMutableArray *accountsOnFile = [[NSMutableArray alloc] init];
    for (GCBasicPaymentProduct *product in self.paymentProducts) {
        [accountsOnFile addObjectsFromArray:product.accountsOnFile.accountsOnFile];
    }
    return accountsOnFile;
}

- (NSString *)logoPathForPaymentProduct:(NSString *)paymentProductIdentifier
{
    GCBasicPaymentProduct *product = [self paymentProductWithIdentifier:paymentProductIdentifier];
    return product.displayHints.logoPath;
}

- (GCBasicPaymentProduct *)paymentProductWithIdentifier:(NSString *)paymentProductIdentifier
{
    for (GCBasicPaymentProduct *product in self.paymentProducts) {
        if ([product.identifier isEqualToString:paymentProductIdentifier] == YES) {
            return product;
        }
    }
    return nil;
}

- (void)setStringFormatter:(GCStringFormatter *)stringFormatter
{
    for (GCBasicPaymentProduct *basicProduct in self.paymentProducts) {
        [basicProduct setStringFormatter:stringFormatter];
    }
}

- (void)sort
{
    [self.paymentProducts sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        GCBasicPaymentProduct *product1 = (GCBasicPaymentProduct *)obj1;
        GCBasicPaymentProduct *product2 = (GCBasicPaymentProduct *)obj2;
        
        if (product1.displayHints.displayOrder > product2.displayHints.displayOrder) {
            return NSOrderedDescending;
        }
        if (product1.displayHints.displayOrder < product2.displayHints.displayOrder) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
}

@end
