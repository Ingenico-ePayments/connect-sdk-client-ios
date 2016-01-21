//
//  GCLabelTemplate.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 14/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCLabelTemplate.h"
#import "GCLabelTemplateItem.h"

@implementation GCLabelTemplate

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
    for (GCLabelTemplateItem *labelTemplateItem in self.labelTemplateItems) {
        if ([labelTemplateItem.attributeKey isEqualToString:key] == YES) {
            return labelTemplateItem.mask;
        }
    }
    return nil;
}

@end
