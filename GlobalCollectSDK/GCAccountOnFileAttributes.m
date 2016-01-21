//
//  GCAccountOnFileAttributes.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 06/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCAccountOnFileAttributes.h"
#import "GCAccountOnFileAttribute.h"

@implementation GCAccountOnFileAttributes

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
    for (GCAccountOnFileAttribute *attribute in self.attributes) {
        if ([attribute.key isEqualToString:paymentProductFieldId] == YES) {
            return attribute.value;
        }
    }
    return @"";
}

- (BOOL)hasValueForField:(NSString *)paymentProductFieldId
{
    for (GCAccountOnFileAttribute *attribute in self.attributes) {
        if ([attribute.key isEqualToString:paymentProductFieldId] == YES) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)fieldIsReadOnly:(NSString *)paymentProductFieldId
{
    for (GCAccountOnFileAttribute *attribute in self.attributes) {
        if ([attribute.key isEqualToString:paymentProductFieldId] == YES) {
            return attribute.status == GCReadOnly;
        }
    }
    return NO;
}

@end
