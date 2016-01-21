//
//  GCPaymentProductConverter.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 03/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCMacros.h"
#import "GCPaymentProductConverter.h"
#import "GCValidator.h"
#import "GCValidatorLuhn.h"
#import "GCValidatorExpirationDate.h"
#import "GCValidatorRegularExpression.h"
#import "GCValidatorRange.h"
#import "GCValidatorLength.h"
#import "GCValidatorFixedList.h"
#import "GCValidatorEmailAddress.h"
#import "GCValueMappingItem.h"

@implementation GCPaymentProductConverter

- (GCPaymentProduct *)paymentProductFromJSON:(NSDictionary *)rawProduct
{
    GCPaymentProduct *product = [[GCPaymentProduct alloc] init];
    [super setBasicPaymentProduct:product JSON:rawProduct];
    [self setPaymentProductFields:product.fields JSON:[rawProduct objectForKey:@"fields"]];
    
    return product;
}

- (void)setPaymentProductFields:(GCPaymentProductFields *)fields JSON:(NSArray *)rawFields
{
    for (NSDictionary *rawField in rawFields) {
        GCPaymentProductField *field = [self paymentProductFieldFromJSON:rawField];
        [fields.paymentProductFields addObject:field];
    }
    [fields sort];
}

- (GCPaymentProductField *)paymentProductFieldFromJSON:(NSDictionary *)rawField
{
    GCPaymentProductField *field = [[GCPaymentProductField alloc] init];
    [self setDataRestrictions:field.dataRestrictions JSON:[rawField objectForKey:@"dataRestrictions"]];
    field.identifier = [rawField objectForKey:@"id"];
    [self setDisplayHints:field.displayHints JSON:[rawField objectForKey:@"displayHints"]];
    [self setType:field rawField:rawField];

    return field;
}

- (void)setType:(GCPaymentProductField *)field rawField:(NSDictionary *)rawField
{
    NSString *rawType = [rawField objectForKey:@"type"];
    if ([rawType isEqualToString:@"string"] == YES) {
        field.type = GCString;
    } else if ([rawType isEqualToString:@"integer"] == YES) {
        field.type = GCInteger;
    } else if ([rawType isEqualToString:@"expirydate"] == YES) {
        field.type = GCExpirationDate;
    } else if ([rawType isEqualToString:@"numericstring"] == YES) {
        field.type = GCNumericString;
    } else {
        DLog(@"Type %@ in JSON fragment %@ is invalid", rawType, rawField);
    }
}

- (void)setDisplayHints:(GCPaymentProductFieldDisplayHints *)hints JSON:(NSDictionary *)rawHints
{
    hints.alwaysShow = [[rawHints objectForKey:@"alwaysShow"] boolValue];
    hints.displayOrder = [[rawHints objectForKey:@"displayOrder"] integerValue];
    [self setFormElement:hints.formElement JSON:[rawHints objectForKey:@"formElement"]];
    hints.mask = [rawHints objectForKey:@"mask"];
    hints.obfuscate = [[rawHints objectForKey:@"obfuscate"] boolValue];
    [self setPreferredInputType:hints JSON:[rawHints objectForKey:@"preferredInputType"]];
    [self setTooltip:hints.tooltip JSON:[rawHints objectForKey:@"tooltip"]];
}

- (void)setPreferredInputType:(GCPaymentProductFieldDisplayHints *)hints JSON:(NSString *)rawPreferredInputType
{
    if ([rawPreferredInputType isEqualToString:@"StringKeyboard"] == YES) {
        hints.preferredInputType = GCStringKeyboard;
    } else if ([rawPreferredInputType isEqualToString:@"IntegerKeyboard"] == YES) {
        hints.preferredInputType = GCIntegerKeyboard;
    } else if ([rawPreferredInputType isEqualToString:@"EmailAddressKeyboard"]) {
        hints.preferredInputType = GCEmailAddressKeyboard;
    } else if ([rawPreferredInputType isEqualToString:@"PhoneNumberKeyboard"]) {
        hints.preferredInputType = GCPhoneNumberKeyboard;
    } else if (rawPreferredInputType == nil) {
        hints.preferredInputType = GCNoKeyboard;
    } else {
        DLog(@"Preferred input type %@ is invalid", rawPreferredInputType);
    }
}

- (void)setTooltip:(GCTooltip *)tooltip JSON:(NSDictionary *)rawTooltip
{
    tooltip.imagePath = [rawTooltip objectForKey:@"image"];
}

- (void)setFormElement:(GCFormElement *)formElement JSON:(NSDictionary *)rawFormElement
{
    [self setFormElementType:formElement JSON:rawFormElement];
}

- (void)setFormElementType:(GCFormElement *)formElement JSON:(NSDictionary *)rawFormElement
{
    NSString *rawType = [rawFormElement objectForKey:@"type"];
    if ([rawType isEqualToString:@"text"] == YES) {
        formElement.type = GCTextType;
    } else if ([rawType isEqualToString:@"currency"] == YES) {
        formElement.type = GCCurrencyType;
    } else if ([rawType isEqualToString:@"list"] == YES) {
        formElement.type = GCListType;
        [self setValueMapping:formElement JSON:[rawFormElement objectForKey:@"valueMapping"]];
    } else {
        DLog(@"Form element %@ is invalid", rawFormElement);
    }
}

- (void)setValueMapping:(GCFormElement *)formElement JSON:(NSArray *)rawValueMapping
{
    for (NSDictionary *rawValueMappingItem in rawValueMapping) {
        GCValueMappingItem *item = [[GCValueMappingItem alloc] init];
        item.displayName = [rawValueMappingItem objectForKey:@"displayName"];
        item.value = [rawValueMappingItem objectForKey:@"value"];
        [formElement.valueMapping addObject:item];
    }
}

- (void)setDataRestrictions:(GCDataRestrictions *)restrictions JSON:(NSDictionary *)rawRestrictions
{
    restrictions.isRequired = [[rawRestrictions objectForKey:@"isRequired"] boolValue];
    [self setValidators:restrictions.validators JSON:[rawRestrictions objectForKey:@"validators"]];
}

- (void)setValidators:(GCValidators *)validators JSON:(NSDictionary *)rawValidators
{
    GCValidator *validator;
    if ([rawValidators objectForKey:@"luhn"] != nil) {
        validator = [[GCValidatorLuhn alloc] init];
        [validators.validators addObject:validator];
    }
    if ([rawValidators objectForKey:@"expirationDate"] != nil) {
        validator = [[GCValidatorExpirationDate alloc] init];
        [validators.validators addObject:validator];
    }
    if ([rawValidators objectForKey:@"range"] != nil) {
        validator = [self validatorRangeFromJSON:[rawValidators objectForKey:@"range"]];
        [validators.validators addObject:validator];
    }
    if ([rawValidators objectForKey:@"length"] != nil) {
        validator = [self validatorLengthFromJSON:[rawValidators objectForKey:@"length"]];
        [validators.validators addObject:validator];
    }
    if ([rawValidators objectForKey:@"fixedList"] != nil) {
        validator = [self validatorFixedListFromJSON:[rawValidators objectForKey:@"fixedList"]];
        [validators.validators addObject:validator];
    }
    if ([rawValidators objectForKey:@"emailAddress"] != nil) {
        validator = [[GCValidatorEmailAddress alloc] init];
        [validators.validators addObject:validator];
    }
    if ([rawValidators objectForKey:@"regularExpression"] != nil) {
        validator = [self validatorRegularExpressionFromJSON:[rawValidators objectForKey:@"regularExpression"]];
        [validators.validators addObject:validator];
    }
}

- (GCValidatorRegularExpression *)validatorRegularExpressionFromJSON:(NSDictionary *)rawValidator
{
    NSString *rawRegularExpression = [rawValidator objectForKey:@"regularExpression"];
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:rawRegularExpression options:0 error:NULL];
    GCValidatorRegularExpression *validator = [[GCValidatorRegularExpression alloc] initWithRegularExpression:regularExpression];
    return validator;
}

- (GCValidatorRange *)validatorRangeFromJSON:(NSDictionary *)rawValidator
{
    GCValidatorRange *validator = [[GCValidatorRange alloc] init];
    validator.maxValue = [[rawValidator objectForKey:@"maxValue"] integerValue];
    validator.minValue = [[rawValidator objectForKey:@"minValue"] integerValue];
    return validator;
}

- (GCValidatorLength *)validatorLengthFromJSON:(NSDictionary *)rawValidator
{
    GCValidatorLength *validator = [[GCValidatorLength alloc] init];
    validator.maxLength = [[rawValidator objectForKey:@"maxLength"] integerValue];
    validator.minLength = [[rawValidator objectForKey:@"minLength"] integerValue];
    return validator;
}

- (GCValidatorFixedList *)validatorFixedListFromJSON:(NSDictionary *)rawValidator
{
    NSArray *rawValues = [rawValidator objectForKey:@"allowedValues"];
    NSMutableArray *allowedValues = [[NSMutableArray alloc] init];
    for (NSString *value in rawValues) {
        [allowedValues addObject:value];
    }
    GCValidatorFixedList *validator = [[GCValidatorFixedList alloc] initWithAllowedValues:allowedValues];
    return validator;
}

@end
