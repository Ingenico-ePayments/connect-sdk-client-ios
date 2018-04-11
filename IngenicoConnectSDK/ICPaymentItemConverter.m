//
//  ICPaymentItemConverter.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <IngenicoConnectSDK/ICPaymentItemConverter.h>
#import <IngenicoConnectSDK/ICPaymentItem.h>
#import <IngenicoConnectSDK/ICPaymentProductFields.h>
#import <IngenicoConnectSDK/ICPaymentProductField.h>
#import <IngenicoConnectSDK/ICMacros.h>
#import <IngenicoConnectSDK/ICValueMappingItem.h>
#import <IngenicoConnectSDK/ICValidator.h>
#import <IngenicoConnectSDK/ICValidatorLuhn.h>
#import <IngenicoConnectSDK/ICValidatorExpirationDate.h>
#import <IngenicoConnectSDK/ICValidatorEmailAddress.h>
#import <IngenicoConnectSDK/ICValidatorRegularExpression.h>
#import <IngenicoConnectSDK/ICValidatorRange.h>
#import <IngenicoConnectSDK/ICValidatorLength.h>
#import <IngenicoConnectSDK/ICValidatorFixedList.h>
#import <IngenicoConnectSDK/ICValidatorBoletoBancarioRequiredness.h>
#import <IngenicoConnectSDK/ICDisplayElementsConverter.h>
#import <IngenicoConnectSDK/ICDisplayElement.h>
#import <IngenicoConnectSDK/ICValidatorTermsAndConditions.h>
#import <IngenicoConnectSDK/ICValidatorIBAN.h>
@implementation ICPaymentItemConverter {

}

- (void)setPaymentItem:(NSObject <ICPaymentItem> *)paymentItem JSON:(NSDictionary *)rawPaymentItem {
    [self setBasicPaymentItem:paymentItem JSON:rawPaymentItem];
    [self setPaymentProductFields:paymentItem.fields JSON:rawPaymentItem[@"fields"]];
}

//Product Fields converter
- (void)setPaymentProductFields:(ICPaymentProductFields *)fields JSON:(NSArray *)rawFields
{
    for (NSDictionary *rawField in rawFields) {
        ICPaymentProductField *field = [self paymentProductFieldFromJSON:rawField];
        [fields.paymentProductFields addObject:field];
    }
    [fields sort];
}

- (ICPaymentProductField *)paymentProductFieldFromJSON:(NSDictionary *)rawField
{
    ICPaymentProductField *field = [[ICPaymentProductField alloc] init];
    [self setDataRestrictions:field.dataRestrictions JSON:[rawField objectForKey:@"dataRestrictions"]];
    field.identifier = [rawField objectForKey:@"id"];
    field.usedForLookup = ((NSNumber *)[rawField objectForKey:@"usedForLookup"]).boolValue;
    [self setDisplayHints:field.displayHints JSON:[rawField objectForKey:@"displayHints"]];
    [self setType:field rawField:rawField];

    return field;
}

- (void)setType:(ICPaymentProductField *)field rawField:(NSDictionary *)rawField
{
    NSString *rawType = [rawField objectForKey:@"type"];
    if ([rawType isEqualToString:@"string"]) {
        field.type = ICString;
    } else if ([rawType isEqualToString:@"integer"]) {
        field.type = ICInteger;
    } else if ([rawType isEqualToString:@"expirydate"]) {
        field.type = ICExpirationDate;
    } else if ([rawType isEqualToString:@"numericstring"]) {
        field.type = ICNumericString;
    } else if ([rawType isEqualToString:@"boolean"]){
        field.type = ICBooleanString;
    } else if ([rawType isEqualToString:@"date"]){
        field.type = ICDateString;
    } else {
        DLog(@"Type %@ in JSON fragment %@ is invalid", rawType, rawField);
    }
}

- (void)setDisplayHints:(ICPaymentProductFieldDisplayHints *)hints JSON:(NSDictionary *)rawHints
{
    hints.alwaysShow = [[rawHints objectForKey:@"alwaysShow"] boolValue];
    hints.displayOrder = [[rawHints objectForKey:@"displayOrder"] integerValue];
    [self setFormElement:hints.formElement JSON:[rawHints objectForKey:@"formElement"]];
    hints.mask = [rawHints objectForKey:@"mask"];
    hints.obfuscate = [[rawHints objectForKey:@"obfuscate"] boolValue];
    hints.label = [rawHints objectForKey:@"label"];
    hints.link = [NSURL URLWithString:[rawHints objectForKey:@"link"]];
    [self setPreferredInputType:hints JSON:[rawHints objectForKey:@"preferredInputType"]];
    [self setTooltip:hints.tooltip JSON:[rawHints objectForKey:@"tooltip"]];
}

- (void)setPreferredInputType:(ICPaymentProductFieldDisplayHints *)hints JSON:(NSString *)rawPreferredInputType
{
    if ([rawPreferredInputType isEqualToString:@"StringKeyboard"] == YES) {
        hints.preferredInputType = ICStringKeyboard;
    } else if ([rawPreferredInputType isEqualToString:@"IntegerKeyboard"] == YES) {
        hints.preferredInputType = ICIntegerKeyboard;
    } else if ([rawPreferredInputType isEqualToString:@"EmailAddressKeyboard"]) {
        hints.preferredInputType = ICEmailAddressKeyboard;
    } else if ([rawPreferredInputType isEqualToString:@"PhoneNumberKeyboard"]) {
        hints.preferredInputType = ICPhoneNumberKeyboard;
    } else if ([rawPreferredInputType isEqualToString:@"DateKeyboard"]) {
        hints.preferredInputType = ICDateKeyboard;
    } else if (rawPreferredInputType == nil) {
        hints.preferredInputType = ICNoKeyboard;
    } else {
        DLog(@"Preferred input type %@ is invalid", rawPreferredInputType);
    }
}

- (void)setTooltip:(ICTooltip *)tooltip JSON:(NSDictionary *)rawTooltip
{
    tooltip.imagePath = [rawTooltip objectForKey:@"image"];
}

- (void)setFormElement:(ICFormElement *)formElement JSON:(NSDictionary *)rawFormElement
{
    [self setFormElementType:formElement JSON:rawFormElement];
}

- (void)setFormElementType:(ICFormElement *)formElement JSON:(NSDictionary *)rawFormElement
{
    NSString *rawType = [rawFormElement objectForKey:@"type"];
    if ([rawType isEqualToString:@"text"] == YES) {
        formElement.type = ICTextType;
    } else if ([rawType isEqualToString:@"currency"] == YES) {
        formElement.type = ICCurrencyType;
    } else if ([rawType isEqualToString:@"list"] == YES) {
        formElement.type = ICListType;
        [self setValueMapping:formElement JSON:[rawFormElement objectForKey:@"valueMapping"]];
    } else if ([rawType isEqualToString:@"date"] == YES) {
        formElement.type = ICDateType;
    } else if ([rawType isEqualToString:@"boolean"] == YES) {
        formElement.type = ICBoolType;
    } else {
        DLog(@"Form element %@ is invalid", rawFormElement);
    }
}

- (void)setValueMapping:(ICFormElement *)formElement JSON:(NSArray *)rawValueMapping
{
    for (NSDictionary *rawValueMappingItem in rawValueMapping) {
        ICValueMappingItem *item = [[ICValueMappingItem alloc] init];
        NSArray *displayElements = [rawValueMappingItem objectForKey:@"displayElements"];
        BOOL foundDisplayElement = NO;
        if (displayElements != nil) {
            ICDisplayElementsConverter *converter = [[ICDisplayElementsConverter alloc]init];
            item.displayElements = [converter displayElementsFromJSON:displayElements];
            for (ICDisplayElement *el in [item displayElements]) {
                if ([el.identifier isEqualToString:@"displayName"]) {
                    item.displayName = el.value;
                    foundDisplayElement = YES;
                }
            }
            if (!foundDisplayElement && item.displayName != nil) {
                ICDisplayElement *el = [[ICDisplayElement alloc]init];
                el.identifier = @"displayName";
                el.value = item.displayName;
                el.type = ICDisplayElementTypeString;
                [item setDisplayElements:[item.displayElements arrayByAddingObject:el]];
            }
        }
        else {
            item.displayName = [rawValueMappingItem objectForKey:@"displayName"];
            ICDisplayElement *el = [[ICDisplayElement alloc]init];
            el.identifier = @"displayName";
            el.value = item.displayName;
            el.type = ICDisplayElementTypeString;
            item.displayElements = [NSArray arrayWithObject:el];
        }
        item.displayName = [rawValueMappingItem objectForKey:@"displayName"];
        item.value = [rawValueMappingItem objectForKey:@"value"];
        [formElement.valueMapping addObject:item];
    }
}

- (void)setDataRestrictions:(ICDataRestrictions *)restrictions JSON:(NSDictionary *)rawRestrictions
{
    restrictions.isRequired = [[rawRestrictions objectForKey:@"isRequired"] boolValue];
    [self setValidators:restrictions.validators JSON:[rawRestrictions objectForKey:@"validators"]];
}

- (void)setValidators:(ICValidators *)validators JSON:(NSDictionary *)rawValidators
{
    ICValidator *validator;
    if ([rawValidators objectForKey:@"luhn"] != nil) {
        validator = [[ICValidatorLuhn alloc] init];
        [validators.validators addObject:validator];
    }
    if ([rawValidators objectForKey:@"expirationDate"] != nil) {
        validator = [[ICValidatorExpirationDate alloc] init];
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
        validator = [[ICValidatorEmailAddress alloc] init];
        [validators.validators addObject:validator];
    }
    if ([rawValidators objectForKey:@"regularExpression"] != nil) {
        validator = [self validatorRegularExpressionFromJSON:[rawValidators objectForKey:@"regularExpression"]];
        [validators.validators addObject:validator];
    }
    if ([rawValidators objectForKey:@"termsAndConditions"] != nil) {
        validator = [[ICValidatorTermsAndConditions alloc] init];
        [validators.validators addObject:validator];
    }
    if ([rawValidators objectForKey:@"iban"] != nil) {
        validator = [[ICValidatorIBAN alloc] init];
        [validators.validators addObject:validator];
    }
    if ([rawValidators objectForKey:@"boletoBancarioRequiredness"] != nil) {
        validator = [self validatorBoletoBancarioRequirednessFromJSON:[rawValidators objectForKey:@"boletoBancarioRequiredness"]];
        [validators.validators addObject:validator];
        validators.containsSomeTimesRequiredValidator = YES;
    }
}

- (ICValidatorRegularExpression *)validatorRegularExpressionFromJSON:(NSDictionary *)rawValidator
{
    NSString *rawRegularExpression = [rawValidator objectForKey:@"regularExpression"];
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:rawRegularExpression options:0 error:NULL];
    ICValidatorRegularExpression *validator = [[ICValidatorRegularExpression alloc] initWithRegularExpression:regularExpression];
    return validator;
}

- (ICValidatorRange *)validatorRangeFromJSON:(NSDictionary *)rawValidator
{
    ICValidatorRange *validator = [[ICValidatorRange alloc] init];
    validator.maxValue = [[rawValidator objectForKey:@"maxValue"] integerValue];
    validator.minValue = [[rawValidator objectForKey:@"minValue"] integerValue];
    return validator;
}

- (ICValidatorLength *)validatorLengthFromJSON:(NSDictionary *)rawValidator
{
    ICValidatorLength *validator = [[ICValidatorLength alloc] init];
    validator.maxLength = [[rawValidator objectForKey:@"maxLength"] integerValue];
    validator.minLength = [[rawValidator objectForKey:@"minLength"] integerValue];
    return validator;
}

- (ICValidatorFixedList *)validatorFixedListFromJSON:(NSDictionary *)rawValidator
{
    NSArray *rawValues = [rawValidator objectForKey:@"allowedValues"];
    NSMutableArray *allowedValues = [[NSMutableArray alloc] init];
    for (NSString *value in rawValues) {
        [allowedValues addObject:value];
    }
    ICValidatorFixedList *validator = [[ICValidatorFixedList alloc] initWithAllowedValues:allowedValues];
    return validator;
}

- (ICValidatorBoletoBancarioRequiredness *)validatorBoletoBancarioRequirednessFromJSON:(NSDictionary *)rawValidator
{
    ICValidatorBoletoBancarioRequiredness *validator = [[ICValidatorBoletoBancarioRequiredness alloc] init];
    validator.fiscalNumberLength = [[rawValidator objectForKey:@"fiscalNumberLength"] integerValue];
    return validator;
}

@end
