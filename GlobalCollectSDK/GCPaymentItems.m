//
//  GCPaymentItems.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 19/05/16.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCPaymentItems.h"
#import "GCBasicPaymentItem.h"
#import "GCStringFormatter.h"
#import "GCPaymentItemDisplayHints.h"
#import "GCAccountsOnFile.h"
#import "GCBasicPaymentProductGroups.h"
#import "GCBasicPaymentProducts.h"
#import "GCPaymentProductGroup.h"

@interface GCPaymentItems ()

@property (strong, nonatomic) GCStringFormatter *stringFormatter;
@property (nonatomic, strong) NSArray *allPaymentItems;

@end

@implementation GCPaymentItems

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.paymentItems = [[NSMutableArray alloc] init];
        self.allPaymentItems = [[NSMutableArray alloc] init];
    }
    return self;
}

-(instancetype)initWithPaymentProducts:(GCBasicPaymentProducts *)products groups:(GCBasicPaymentProductGroups *)groups {
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

-(NSArray *)createPaymentItemsFromProducts:(GCBasicPaymentProducts *)products groups:(GCBasicPaymentProductGroups *)groups {
    NSMutableArray *paymentItems = [NSMutableArray new];

    for (GCBasicPaymentProduct *product in products.paymentProducts) {
        BOOL groupMatch = NO;

        //Check if the product belongs to a group
        if (product.paymentProductGroup != nil) {
            for (GCPaymentProductGroup *group in groups.paymentProductGroups) {
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
    for (NSObject<GCBasicPaymentItem> *paymentItem in self.paymentItems) {
        if (paymentItem.accountsOnFile.accountsOnFile.count > 0) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)accountsOnFile
{
    NSMutableArray *accountsOnFile = [[NSMutableArray alloc] init];
    for (NSObject<GCBasicPaymentItem> *paymentItem in self.paymentItems) {
        [accountsOnFile addObjectsFromArray:paymentItem.accountsOnFile.accountsOnFile];
    }
    return accountsOnFile;
}

- (NSString *)logoPathForPaymentItem:(NSString *)paymentItemIdentifier
{
    NSObject<GCBasicPaymentItem> *paymentItem = [self paymentItemWithIdentifier:paymentItemIdentifier];
    return paymentItem.displayHints.logoPath;
}

- (NSObject<GCBasicPaymentItem> *)paymentItemWithIdentifier:(NSString *)paymentItemIdentifier
{
    for (NSObject<GCBasicPaymentItem> *paymentItem in self.allPaymentItems) {
        if ([paymentItem.identifier isEqualToString:paymentItemIdentifier] == YES) {
            return paymentItem;
        }
    }
    return nil;
}

- (void)sort
{
    [self.paymentItems sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSObject<GCBasicPaymentItem> *paymentItem1 = (NSObject<GCBasicPaymentItem> *)obj1;
        NSObject<GCBasicPaymentItem> *paymentItem2 = (NSObject<GCBasicPaymentItem> *)obj2;

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
