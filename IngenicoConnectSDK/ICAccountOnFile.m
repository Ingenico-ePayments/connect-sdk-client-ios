//
//  ICAccountOnFile.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <IngenicoConnectSDK/ICAccountOnFile.h>
#import <IngenicoConnectSDK/ICLabelTemplateItem.h>

@interface ICAccountOnFile ()

@property (strong, nonatomic) ICStringFormatter *stringFormatter;

@end

@implementation ICAccountOnFile

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.displayHints = [[ICAccountOnFileDisplayHints alloc] init];
        self.attributes = [[ICAccountOnFileAttributes alloc] init];
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
    for (ICLabelTemplateItem *labelTemplateItem in self.displayHints.labelTemplate.labelTemplateItems) {
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
