//
//  ICAccountOnFileAttributes.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <IngenicoConnectSDK/ICAccountOnFileAttributes.h>
#import <IngenicoConnectSDK/ICAccountOnFileAttribute.h>

@implementation ICAccountOnFileAttributes

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.attributes = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)valueForField:(NSString *)paymentProductFieldId
{
    for (ICAccountOnFileAttribute *attribute in self.attributes) {
        if ([attribute.key isEqualToString:paymentProductFieldId] == YES) {
            return attribute.value;
        }
    }
    return @"";
}

- (BOOL)hasValueForField:(NSString *)paymentProductFieldId
{
    for (ICAccountOnFileAttribute *attribute in self.attributes) {
        if ([attribute.key isEqualToString:paymentProductFieldId] == YES) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)fieldIsReadOnly:(NSString *)paymentProductFieldId
{
    for (ICAccountOnFileAttribute *attribute in self.attributes) {
        if ([attribute.key isEqualToString:paymentProductFieldId] == YES) {
            return attribute.status == ICReadOnly;
        }
    }
    return NO;
}

@end
