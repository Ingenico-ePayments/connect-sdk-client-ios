//
//  ICPaymentItems.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICPaymentItems.h"
#import  "ICBasicPaymentItem.h"
#import  "ICStringFormatter.h"
#import  "ICPaymentItemDisplayHints.h"
#import  "ICAccountsOnFile.h"
#import  "ICBasicPaymentProductGroups.h"
#import  "ICBasicPaymentProducts.h"
#import  "ICPaymentProductGroup.h"

@interface ICPaymentItems ()

@property (strong, nonatomic) ICStringFormatter *stringFormatter;
@property (nonatomic, strong) NSArray *allPaymentItems;

@end

@implementation ICPaymentItems

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.paymentItems = [[NSMutableArray alloc] init];
        self.allPaymentItems = [[NSMutableArray alloc] init];
    }
    return self;
}

-(instancetype)initWithPaymentProducts:(ICBasicPaymentProducts *)products groups:(ICBasicPaymentProductGroups *)groups {
    self = [self init];
    if (self != nil) {
        self.paymentItems = [NSMutableArray arrayWithArray:[self createPaymentItemsFromProducts:products groups:groups]];
        if (groups != nil) {
            self.allPaymentItems = [products.paymentProducts arrayByAddingObjectsFromArray:groups.paymentProductGroups];
        } else {
            self.allPaymentItems = products.paymentProducts;
        }

    }
    return self;
}

-(NSArray *)createPaymentItemsFromProducts:(ICBasicPaymentProducts *)products groups:(ICBasicPaymentProductGroups *)groups {
    NSMutableArray *paymentItems = [NSMutableArray new];

    for (ICBasicPaymentProduct *product in products.paymentProducts) {
        BOOL groupMatch = NO;

        //Check if the product belongs to a group
        if (product.paymentProductGroup != nil) {
            for (ICPaymentProductGroup *group in groups.paymentProductGroups) {
                if ([product.paymentProductGroup isEqualToString:group.identifier] && ![paymentItems containsObject:group]) {
                    group.displayHints.displayOrder = product.displayHints.displayOrder;
                    [paymentItems addObject:group];
                }

                groupMatch = YES;
                break;
            }
        }
        if (!groupMatch) {
            [paymentItems addObject:product];
        }
    }

    return [NSArray arrayWithArray:paymentItems];
}

- (BOOL)hasAccountsOnFile
{
    for (NSObject<ICBasicPaymentItem> *paymentItem in self.paymentItems) {
        if (paymentItem.accountsOnFile.accountsOnFile.count > 0) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)accountsOnFile
{
    NSMutableArray *accountsOnFile = [[NSMutableArray alloc] init];
    for (NSObject<ICBasicPaymentItem> *paymentItem in self.paymentItems) {
        [accountsOnFile addObjectsFromArray:paymentItem.accountsOnFile.accountsOnFile];
    }
    return accountsOnFile;
}

- (NSString *)logoPathForPaymentItem:(NSString *)paymentItemIdentifier
{
    NSObject<ICBasicPaymentItem> *paymentItem = [self paymentItemWithIdentifier:paymentItemIdentifier];
    return paymentItem.displayHints.logoPath;
}

- (NSObject<ICBasicPaymentItem> *)paymentItemWithIdentifier:(NSString *)paymentItemIdentifier
{
    for (NSObject<ICBasicPaymentItem> *paymentItem in self.allPaymentItems) {
        if ([paymentItem.identifier isEqualToString:paymentItemIdentifier] == YES) {
            return paymentItem;
        }
    }
    return nil;
}

- (void)sort
{
    [self.paymentItems sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSObject<ICBasicPaymentItem> *paymentItem1 = (NSObject<ICBasicPaymentItem> *)obj1;
        NSObject<ICBasicPaymentItem> *paymentItem2 = (NSObject<ICBasicPaymentItem> *)obj2;

        if (paymentItem1.displayHints.displayOrder > paymentItem2.displayHints.displayOrder) {
            return NSOrderedDescending;
        }
        if (paymentItem1.displayHints.displayOrder < paymentItem2.displayHints.displayOrder) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
}

@end
