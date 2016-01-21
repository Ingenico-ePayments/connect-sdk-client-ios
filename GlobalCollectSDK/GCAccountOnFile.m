//
//  GCAccountOnFile.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCAccountOnFile.h"
#import "GCLabelTemplateItem.h"

@interface GCAccountOnFile ()

@property (strong, nonatomic) GCStringFormatter *stringFormatter;

@end

@implementation GCAccountOnFile

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.displayHints = [[GCAccountOnFileDisplayHints alloc] init];
        self.attributes = [[GCAccountOnFileAttributes alloc] init];
    }
    return self;
}

- (NSString *)maskedValueForField:(NSString *)paymentProductFieldId
{
    NSString *mask = [self.displayHints.labelTemplate maskForAttributeKey:paymentProductFieldId];
    return [self maskedValueForField:paymentProductFieldId mask:mask];
}

- (NSString *)maskedValueForField:(NSString *)paymentProductFieldId mask:(NSString *)mask
{
    NSString *value = [self.attributes valueForField:paymentProductFieldId];
    if (mask == nil) {
        return value;
    } else {
        NSString *relaxedMask = [self.stringFormatter relaxMask:mask];
        return [self.stringFormatter formatString:value withMask:relaxedMask];
    }
}

- (BOOL)hasValueForField:(NSString *)paymentProductFieldId
{
    return [self.attributes hasValueForField:paymentProductFieldId];
}

- (BOOL)fieldIsReadOnly:(NSString *)paymentProductFieldId
{
    return [self.attributes fieldIsReadOnly:paymentProductFieldId];
}

- (NSString *)label
{
    NSMutableArray *labelComponents = [[NSMutableArray alloc] init];
    for (GCLabelTemplateItem *labelTemplateItem in self.displayHints.labelTemplate.labelTemplateItems) {
        NSString *value = [self maskedValueForField:labelTemplateItem.attributeKey];
        if (value != nil && [value isEqualToString:@""] == NO) {
            NSString *trimmedValue = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [labelComponents addObject:trimmedValue];
        }
    }
    NSString *label = [labelComponents componentsJoinedByString:@" "];
    return label;
}

@end
