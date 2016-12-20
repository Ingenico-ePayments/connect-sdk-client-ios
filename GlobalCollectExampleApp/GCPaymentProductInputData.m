//
//  GCPaymentProductInputData.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 18/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import "GCPaymentProductInputData.h"
#import "GCPaymentItem.h"
#import "GCAccountOnFile.h"
#import "GCPaymentProductField.h"
#import "GCAccountOnFileAttribute.h"
#import "GCValidator.h"
#import "GCValidatorFixedList.h"
#import "GCPaymentProductFields.h"
#import "GCPaymentRequest.h"

@interface GCPaymentProductInputData ()

@property (strong, nonatomic) NSMutableDictionary *fieldValues;
@property (strong, nonatomic) GCStringFormatter *formatter;

@end

@implementation GCPaymentProductInputData

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.formatter = [[GCStringFormatter alloc] init];
        self.fieldValues = [[NSMutableDictionary alloc] init];
        self.errors = [NSMutableArray new];
    }
    return self;
}

- (GCPaymentRequest *)paymentRequest {
    GCPaymentRequest *paymentRequest = [GCPaymentRequest new];

    if ([self.paymentItem isKindOfClass:[GCPaymentProduct class]]) {
        paymentRequest.paymentProduct = (GCPaymentProduct *) self.paymentItem;
    }
    else {
        paymentRequest.paymentProduct = [GCPaymentProduct new];
    }

    paymentRequest.accountOnFile = self.accountOnFile;
    paymentRequest.tokenize = self.tokenize;
    for (NSString *key in self.fieldValues.allKeys) {
        NSString *value = self.fieldValues[key];
        [paymentRequest setValue:value forField:key];
    }

    return paymentRequest;
}


- (void)setValue:(NSString *)value forField:(NSString *)paymentProductFieldId {
    [self.fieldValues setObject:value forKey:paymentProductFieldId];
}

- (NSString *)valueForField:(NSString *)paymentProductFieldId {
    NSString *value = [self.fieldValues objectForKey:paymentProductFieldId];
    if (value == nil) {
        value = @"";
        GCPaymentProductField *field = [self.paymentItem paymentProductFieldWithId:paymentProductFieldId];
        for (GCValidator *validator in field.dataRestrictions.validators.validators) {
            if ([validator class] == [GCValidatorFixedList class]) {
                GCValidatorFixedList *fixedListValidator = (GCValidatorFixedList *) validator;
                value = fixedListValidator.allowedValues[0];
                [self setValue:value forField:paymentProductFieldId];
            }
        }
    }
    return value;
}

- (NSString *)maskedValueForField:(NSString *)paymentProductFieldId {
    NSInteger cursorPosition = 0;
    return [self maskedValueForField:paymentProductFieldId cursorPosition:&cursorPosition];
}

- (NSString *)maskedValueForField:(NSString *)paymentProductFieldId cursorPosition:(NSInteger *)cursorPosition {
    NSString *value = [self valueForField:paymentProductFieldId];
    NSString *mask = [self maskForField:paymentProductFieldId];
    if (mask == nil) {
        return value;
    } else {
        return [self.formatter formatString:value withMask:mask cursorPosition:cursorPosition];
    }
}

- (NSString *)unmaskedValueForField:(NSString *)paymentProductFieldId {
    NSString *value = [self valueForField:paymentProductFieldId];
    NSString *mask = [self maskForField:paymentProductFieldId];
    if (mask == nil) {
        return value;
    } else {
        NSString *unformattedString = [self.formatter unformatString:value withMask:mask];
        return unformattedString;
    }
}

- (BOOL)fieldIsPartOfAccountOnFile:(NSString *)paymentProductFieldId {
    return [self.accountOnFile hasValueForField:paymentProductFieldId];
}

- (BOOL)fieldIsReadOnly:(NSString *)paymentProductFieldId {
    if ([self fieldIsPartOfAccountOnFile:paymentProductFieldId] == NO) {
        return NO;
    } else {
        return [self.accountOnFile fieldIsReadOnly:paymentProductFieldId];
    }
}

- (void)setAccountOnFile:(GCAccountOnFile *)accountOnFile {
    _accountOnFile = accountOnFile;
    for (GCAccountOnFileAttribute *attribute in accountOnFile.attributes.attributes) {
        [self.fieldValues setObject:attribute.value forKey:attribute.key];
    }
}

- (NSString *)maskForField:(NSString *)paymentProductFieldId {
    GCPaymentProductField *field = [self.paymentItem paymentProductFieldWithId:paymentProductFieldId];
    NSString *mask = field.displayHints.mask;
    return mask;
}

- (NSDictionary *)unmaskedFieldValues {
    NSMutableDictionary *unmaskedFieldValues = [@{} mutableCopy];
    for (GCPaymentProductField *field in self.paymentItem.fields.paymentProductFields) {
        NSString *fieldId = field.identifier;
        if ([self fieldIsReadOnly:fieldId] == NO) {
            NSString *unmaskedValue = [self unmaskedValueForField:fieldId];
            [unmaskedFieldValues setObject:unmaskedValue forKey:fieldId];
        }
    }
    return unmaskedFieldValues;
}

- (void)validate
{
    [self.errors removeAllObjects];
    for (GCPaymentProductField *field in self.paymentItem.fields.paymentProductFields) {
        if ([self fieldIsPartOfAccountOnFile:field.identifier] == NO) {
            NSString *fieldValue = [self unmaskedValueForField:field.identifier];
            [field validateValue:fieldValue];
            [self.errors addObjectsFromArray:field.errors];
        }
    }
}

@end
