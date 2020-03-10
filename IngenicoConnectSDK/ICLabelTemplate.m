//
//  ICLabelTemplate.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICLabelTemplate.h"
#import  "ICLabelTemplateItem.h"

@implementation ICLabelTemplate

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.labelTemplateItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)maskForAttributeKey:(NSString *)key
{
    for (ICLabelTemplateItem *labelTemplateItem in self.labelTemplateItems) {
        if ([labelTemplateItem.attributeKey isEqualToString:key] == YES) {
            return labelTemplateItem.mask;
        }
    }
    return nil;
}

@end
