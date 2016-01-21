//
//  GCFormRowsConverter.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 10/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCSDKConstants.h"
#import "GCMacros.h"
#import "GCValidator.h"
#import "GCValidatorFixedList.h"
#import "GCFormRowsConverter.h"
#import "GCPaymentProductField.h"
#import "GCFormRowList.h"
#import "GCFormRowTextField.h"
#import "GCFormRowCurrency.h"
#import "GCFormRowLabel.h"
#import "GCFormRowErrorMessage.h"
#import "GCValidationError.h"
#import "GCValidationErrorLength.h"
#import "GCValidationErrorRange.h"
#import "GCValidationErrorExpirationDate.h"
#import "GCValidationErrorFixedList.h"
#import "GCValidationErrorLuhn.h"
#import "GCValidationErrorRegularExpression.h"
#import "GCValidationErrorIsRequired.h"
#import "GCValueMappingItem.h"

@implementation GCFormRowsConverter

- (NSMutableArray *)formRowsFromPaymentRequest:(GCPaymentRequest *)paymentRequest validation:(BOOL)validation confirmedPaymentProducts:(NSSet *)confirmedPaymentProducts viewFactory:(GCViewFactory *)viewFactory
{
    NSMutableArray *rows = [[NSMutableArray alloc] init];
    for (GCPaymentProductField* field in paymentRequest.paymentProduct.fields.paymentProductFields) {
        GCFormRow *row;
        BOOL isPartOfAccountOnFile = [paymentRequest fieldIsPartOfAccountOnFile:field.identifier];
        NSString *value;
        BOOL isEnabled;
        if (isPartOfAccountOnFile == YES) {
            NSString *mask = field.displayHints.mask;
            value = [paymentRequest.accountOnFile maskedValueForField:field.identifier mask:mask];
            isEnabled = [paymentRequest fieldIsReadOnly:field.identifier] == NO;
        } else {
            value = [paymentRequest maskedValueForField:field.identifier];
            isEnabled = YES;
        }
        row = [self labelFormRowFromField:field paymentProduct:paymentRequest.paymentProduct.identifier viewFactory:viewFactory];
        [rows addObject:row];
        switch (field.displayHints.formElement.type) {
            case GCListType: {
                row = [self listFormRowFromField:field value:value isEnabled:isEnabled viewFactory:viewFactory];
                break;
            }
            case GCTextType: {
                row = [self textFieldFormRowFromField:field paymentProduct:paymentRequest.paymentProduct value:value isEnabled:isEnabled confirmedPaymentProducts:confirmedPaymentProducts viewFactory:viewFactory];
                break;
            }
            case GCCurrencyType: {
                row = [self currencyFormRowFromField:field paymentProduct:paymentRequest.paymentProduct value:value isEnabled:isEnabled viewFactory:viewFactory];
                break;
            }
            default: {
                [NSException raise:@"Invalid form element type" format:@"Form element type %d is invalid", field.displayHints.formElement.type];
                break;
            }
        }
        [rows addObject:row];
        if (validation == YES) {
            if (field.errors.count > 0) {
                row = [self errorFormRowWithError:field.errors.firstObject forCurrency:field.displayHints.formElement.type == GCCurrencyType];
                [rows addObject:row];
            }
        }
    }
    return rows;
}

- (GCFormRowErrorMessage *)errorFormRowWithError:(GCValidationError *)error forCurrency:(BOOL)forCurrency
{
    GCFormRowErrorMessage *row = [[GCFormRowErrorMessage alloc] init];
    Class errorClass = [error class];
    NSString *errorMessageFormat = @"gc.general.paymentProductFields.validationErrors.%@.label";
    NSString *errorMessageKey;
    NSString *errorMessageValue;
    NSString *errorMessage;
    if (errorClass == [GCValidationErrorLength class]) {
        GCValidationErrorLength *lengthError = (GCValidationErrorLength *)error;
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"length"];
        NSString *errorMessageValueWithPlaceholders = NSLocalizedStringFromTable(errorMessageKey, kGCSDKLocalizable, nil);
        NSString *errorMessageValueWithPlaceholder = [errorMessageValueWithPlaceholders stringByReplacingOccurrencesOfString:@"{maxLength}" withString:@"\%ld"];
        errorMessageValue = [errorMessageValueWithPlaceholder stringByReplacingOccurrencesOfString:@"{minLength}" withString:@"\%ld"];
        errorMessage = [NSString stringWithFormat:errorMessageValue, lengthError.minLength, lengthError.maxLength];
    } else if (errorClass == [GCValidationErrorRange class]) {
        GCValidationErrorRange *rangeError = (GCValidationErrorRange *)error;
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"range"];
        NSString *errorMessageValueWithPlaceholders = NSLocalizedStringFromTable(errorMessageKey, kGCSDKLocalizable, nil);
        NSString *errorMessageValueWithPlaceholder = [errorMessageValueWithPlaceholders stringByReplacingOccurrencesOfString:@"{minValue}" withString:@"\%@"];
        errorMessageValue = [errorMessageValueWithPlaceholder stringByReplacingOccurrencesOfString:@"{maxValue}" withString:@"\%@"];
        NSString *minString;
        NSString *maxString;
        if (forCurrency == YES) {
            minString = [NSString stringWithFormat:@"%.2f", (double)rangeError.minValue / 100];
            maxString = [NSString stringWithFormat:@"%.2f", (double)rangeError.maxValue / 100];
        } else {
            minString = [NSString stringWithFormat:@"%ld", (long)rangeError.minValue];
            maxString = [NSString stringWithFormat:@"%ld", (long)rangeError.maxValue];
        }
        errorMessage = [NSString stringWithFormat:errorMessageValue, minString, maxString];
    } else if (errorClass == [GCValidationErrorExpirationDate class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"expirationDate"];
        errorMessageValue = NSLocalizedStringFromTable(errorMessageKey, kGCSDKLocalizable, nil);
        errorMessage = errorMessageValue;
    } else if (errorClass == [GCValidationErrorFixedList class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"fixedList"];
        errorMessageValue = NSLocalizedStringFromTable(errorMessageKey, kGCSDKLocalizable, nil);
        errorMessage = errorMessageValue;
    } else if (errorClass == [GCValidationErrorLuhn class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"luhn"];
        errorMessageValue = NSLocalizedStringFromTable(errorMessageKey, kGCSDKLocalizable, nil);
        errorMessage = errorMessageValue;
    } else if (errorClass == [GCValidationErrorRegularExpression class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"regularExpression"];
        errorMessageValue = NSLocalizedStringFromTable(errorMessageKey, kGCSDKLocalizable, nil);
        errorMessage = errorMessageValue;
    } else if (errorClass == [GCValidationErrorIsRequired class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"required"];
        errorMessageValue = NSLocalizedStringFromTable(errorMessageKey, kGCSDKLocalizable, nil);
        errorMessage = errorMessageValue;
    } else {
        [NSException raise:@"Invalid validation error" format:@"Validation error %@ is invalid", error];
    }
    row.errorMessage = errorMessage;
    return row;
}

- (GCFormRowTextField *)textFieldFormRowFromField:(GCPaymentProductField *)field paymentProduct:(GCPaymentProduct *)paymentProduct value:(NSString *)value isEnabled:(BOOL)isEnabled confirmedPaymentProducts:(NSSet *)confirmedPaymentProducts viewFactory:(GCViewFactory *)viewFactory
{
    GCFormRowTextField *row = [[GCFormRowTextField alloc] init];
    row.textField = (GCTextField *)[viewFactory textFieldWithType:GCTextFieldType];
    NSString *placeholderKey = [NSString stringWithFormat:@"gc.general.paymentProductFields.%@.placeholder.%@", field.identifier, paymentProduct.identifier];
    NSString *placeholderValue = NSLocalizedStringFromTable(placeholderKey, kGCSDKLocalizable, nil);
    if ([placeholderKey isEqualToString:placeholderValue] == YES) {
        placeholderKey = [NSString stringWithFormat:@"gc.general.paymentProductFields.%@.placeholder", field.identifier];
        placeholderValue = NSLocalizedStringFromTable(placeholderKey, kGCSDKLocalizable, nil);
    }
    row.textField.placeholder = placeholderValue;
    if (field.displayHints.preferredInputType == GCIntegerKeyboard) {
        row.textField.keyboardType = UIKeyboardTypeNumberPad;
    } else if (field.displayHints.preferredInputType == GCEmailAddressKeyboard) {
        row.textField.keyboardType = UIKeyboardTypeEmailAddress;
    } else if (field.displayHints.preferredInputType == GCPhoneNumberKeyboard) {
        row.textField.keyboardType = UIKeyboardTypePhonePad;
    }
    row.textField.secureTextEntry = field.displayHints.obfuscate;
    row.textField.text = value;
    [row.textField setEnabled:isEnabled];
    row.textField.rightViewMode = UITextFieldViewModeAlways;
    row.paymentProductField = field;
    
    if ([field.identifier isEqualToString:@"cardNumber"] == YES) {
        row.logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        row.logo.contentMode = UIViewContentModeScaleAspectFit;
        row.logo.image = paymentProduct.displayHints.logoImage;
        if ([confirmedPaymentProducts member:paymentProduct.identifier] != nil) {
            row.textField.rightView = row.logo;
        }
    }
    
    [self setTooltipForFormRow:row withField:field paymentProduct:paymentProduct];

    return row;
}

- (GCFormRowCurrency *)currencyFormRowFromField:(GCPaymentProductField *)field paymentProduct:(GCPaymentProduct *)paymentProduct value:(NSString *)value isEnabled:(BOOL)isEnabled viewFactory:(GCViewFactory *)viewFactory
{
    GCFormRowCurrency *row = [[GCFormRowCurrency alloc] init];
    row.integerTextField = (GCIntegerTextField *)[viewFactory textFieldWithType:GCIntegerTextFieldType];
    row.fractionalTextField = (GCFractionalTextField *)[viewFactory textFieldWithType:GCFractionalTextFieldType];
    NSString *placeholderKey = [NSString stringWithFormat:@"gc.general.paymentProductFields.%@.placeholder.%@", field.identifier, paymentProduct.identifier];
    NSString *placeholderValue = NSLocalizedStringFromTable(placeholderKey, kGCSDKLocalizable, nil);
    if ([placeholderKey isEqualToString:placeholderValue] == YES) {
        placeholderKey = [NSString stringWithFormat:@"gc.general.paymentProductFields.%@.placeholder", field.identifier];
        placeholderValue = NSLocalizedStringFromTable(placeholderKey, kGCSDKLocalizable, nil);
    }
    row.integerTextField.placeholder = placeholderValue;
    if (field.displayHints.preferredInputType == GCIntegerKeyboard) {
        row.integerTextField.keyboardType = UIKeyboardTypeNumberPad;
        row.fractionalTextField.keyboardType = UIKeyboardTypeNumberPad;
    } else if (field.displayHints.preferredInputType == GCEmailAddressKeyboard) {
        row.integerTextField.keyboardType = UIKeyboardTypeEmailAddress;
        row.fractionalTextField.keyboardType = UIKeyboardTypeEmailAddress;
    } else if (field.displayHints.preferredInputType == GCPhoneNumberKeyboard) {
        row.integerTextField.keyboardType = UIKeyboardTypePhonePad;
        row.fractionalTextField.keyboardType = UIKeyboardTypePhonePad;
    }
    
    long long integerPart = [value longLongValue] / 100;
    int fractionalPart = (int) llabs([value longLongValue] % 100);
    row.integerTextField.secureTextEntry = field.displayHints.obfuscate;
    row.integerTextField.text = [NSString stringWithFormat:@"%lld", integerPart];
    [row.integerTextField setEnabled:isEnabled];
    row.integerTextField.rightViewMode = UITextFieldViewModeNever;
    row.fractionalTextField.secureTextEntry = field.displayHints.obfuscate;
    row.fractionalTextField.text = [NSString stringWithFormat:@"%02d", fractionalPart];
    [row.fractionalTextField setEnabled:isEnabled];
    row.fractionalTextField.rightViewMode = UITextFieldViewModeNever;
    row.paymentProductField = field;
    
    [self setTooltipForFormRow:row withField:field paymentProduct:paymentProduct];
    
    return row;
}

- (void)setTooltipForFormRow:(GCFormRowWithInfoButton *)row withField:(GCPaymentProductField *)field paymentProduct:(GCPaymentProduct *)paymentProduct
{
    if (field.displayHints.tooltip.imagePath != nil) {
        row.showInfoButton = YES;
        NSString *tooltipTextKey = [NSString stringWithFormat:@"gc.general.paymentProductFields.%@.tooltipText.%@", field.identifier, paymentProduct.identifier];
        NSString *tooltipTextValue = NSLocalizedStringFromTable(tooltipTextKey, kGCSDKLocalizable, nil);
        if ([tooltipTextKey isEqualToString:tooltipTextValue] == YES) {
            tooltipTextKey = [NSString stringWithFormat:@"gc.general.paymentProductFields.%@.tooltipText", field.identifier];
            tooltipTextValue = NSLocalizedStringFromTable(tooltipTextKey, kGCSDKLocalizable, nil);
        }
        row.tooltipText = tooltipTextValue;
        row.tooltipImage = field.displayHints.tooltip.image;
    }
}

- (GCFormRowList *)listFormRowFromField:(GCPaymentProductField *)field value:(NSString *)value isEnabled:(BOOL)isEnabled viewFactory:(GCViewFactory *)viewFactory
{
    GCFormRowList *row = [[GCFormRowList alloc] init];
    GCPickerView *pickerView = (GCPickerView *)[viewFactory pickerViewWithType:GCPickerViewType];
    [pickerView setUserInteractionEnabled:isEnabled];
    row.pickerView = pickerView;
    
    NSInteger rowIndex = 0;
    NSMutableDictionary *nameToIdentifierMapping = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *identifierToRowMapping = [[NSMutableDictionary alloc] init];
    NSMutableArray *displayNames = [[NSMutableArray alloc] init];
    for (GCValueMappingItem *item in field.displayHints.formElement.valueMapping) {
        [nameToIdentifierMapping setObject:item.value forKey:item.displayName];
        [identifierToRowMapping setObject:[NSString stringWithFormat:@"%ld", (long)rowIndex] forKey:item.value];
        [displayNames addObject:item.displayName];
        ++rowIndex;
    }

    pickerView.content = displayNames;
    row.nameToIdentifierMapping = nameToIdentifierMapping;
    row.identifierToRowMapping = identifierToRowMapping;
    row.selectedRow = [[identifierToRowMapping objectForKey:value] integerValue];
    row.paymentProductFieldIdentifier = field.identifier;
    return row;
}

- (GCFormRowLabel *)labelFormRowFromField:(GCPaymentProductField *)field paymentProduct:(NSString *)paymentProductId viewFactory:(GCViewFactory *)viewFactory
{
    GCFormRowLabel *row = [[GCFormRowLabel alloc] init];
    GCLabel *label = (GCLabel *)[viewFactory labelWithType:GCLabelType];
    NSString *labelKey = [NSString stringWithFormat:@"gc.general.paymentProductFields.%@.label.%@", field.identifier, paymentProductId];
    NSString *labelValue = NSLocalizedStringFromTable(labelKey, kGCSDKLocalizable, nil);
    if ([labelKey isEqualToString:labelValue] == YES) {
        labelKey = [NSString stringWithFormat:@"gc.general.paymentProductFields.%@.label", field.identifier];
        labelValue = NSLocalizedStringFromTable(labelKey, kGCSDKLocalizable, nil);
    }
    label.text = labelValue;
    row.label = label;
    
    return row;
}

@end
