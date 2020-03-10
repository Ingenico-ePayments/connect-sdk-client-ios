//
//  ICBasicPaymentProducts.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICBasicPaymentProducts.h"

@interface ICBasicPaymentProducts ()

@property (strong, nonatomic) ICStringFormatter *stringFormatter;

@end

@implementation ICBasicPaymentProducts

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
    for (ICBasicPaymentProduct *product in self.paymentProducts) {
        if (product.accountsOnFile.accountsOnFile.count > 0) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)accountsOnFile
{
    NSMutableArray *accountsOnFile = [[NSMutableArray alloc] init];
    for (ICBasicPaymentProduct *product in self.paymentProducts) {
        [accountsOnFile addObjectsFromArray:product.accountsOnFile.accountsOnFile];
    }
    return accountsOnFile;
}

- (NSString *)logoPathForPaymentProduct:(NSString *)paymentProductIdentifier
{
    ICBasicPaymentProduct *product = [self paymentProductWithIdentifier:paymentProductIdentifier];
    return product.displayHints.logoPath;
}

- (ICBasicPaymentProduct *)paymentProductWithIdentifier:(NSString *)paymentProductIdentifier
{
    for (ICBasicPaymentProduct *product in self.paymentProducts) {
        if ([product.identifier isEqualToString:paymentProductIdentifier] == YES) {
            return product;
        }
    }
    return nil;
}

- (void)setStringFormatter:(ICStringFormatter *)stringFormatter
{
    for (ICBasicPaymentProduct *basicProduct in self.paymentProducts) {
        [basicProduct setStringFormatter:stringFormatter];
    }
}

- (void)sort
{
    [self.paymentProducts sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        ICBasicPaymentProduct *product1 = (ICBasicPaymentProduct *)obj1;
        ICBasicPaymentProduct *product2 = (ICBasicPaymentProduct *)obj2;
        
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
