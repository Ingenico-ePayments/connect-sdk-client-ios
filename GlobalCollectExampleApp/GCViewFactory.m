//
//  GCViewFactory.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCViewFactory.h"
#import "GCButtonTableViewCell.h"
#import "GCSwitchTableViewCell.h"
#import "GCErrorMessageTableViewCell.h"
#import "GCLabelTableViewCell.h"
#import "GCTooltipTableViewCell.h"
#import "GCPaymentProductTableViewCell.h"
#import "GCTextFieldTableViewCell.h"
#import "GCPrimaryButton.h"
#import "GCSecondaryButton.h"
#import "GCSwitch.h"
#import "GCPickerViewTableViewCell.h"
#import "GCSummaryTableHeaderView.h"
#import "GCIntegerTextField.h"
#import "GCFractionalTextField.h"
#import "GCCurrencyTableViewCell.h"

@implementation GCViewFactory

- (GCTableViewCell *)tableViewCellWithType:(GCViewType)type reuseIdentifier:(NSString *)reuseIdentifier
{
    GCTableViewCell *cell;
    switch (type) {
        case GCSwitchTableViewCellType:
            cell = [[GCSwitchTableViewCell alloc] initWithReuseIdentifier:reuseIdentifier];
            break;
        case GCErrorMessageTableViewCellType:
            cell = [[GCErrorMessageTableViewCell alloc] initWithReuseIdentifier:reuseIdentifier];
            break;
        case GCTooltipTableViewCellType:
            cell = [[GCTooltipTableViewCell alloc] initWithReuseIdentifier:reuseIdentifier];
            break;
        case GCPaymentProductTableViewCellType:
            cell = [[GCPaymentProductTableViewCell alloc] initWithReuseIdentifier:reuseIdentifier];
            break;
        case GCTextFieldTableViewCellType:
            cell = [[GCTextFieldTableViewCell alloc] initWithReuseIdentifier:reuseIdentifier];
            break;
        case GCCurrencyTableViewCellType:
            cell = [[GCCurrencyTableViewCell alloc] initWithReuseIdentifier:reuseIdentifier];
            break;
        case GCPickerViewTableViewCellType:
            cell = [[GCPickerViewTableViewCell alloc] initWithReuseIdentifier:reuseIdentifier];
            break;
        case GCButtonTableViewCellType:
            cell = [[GCButtonTableViewCell alloc] initWithReuseIdentifier:reuseIdentifier];
            break;
        case GCLabelTableViewCellType:
            cell = [[GCLabelTableViewCell alloc] initWithReuseIdentifier:reuseIdentifier];
            break;
        default:
            [NSException raise:@"Invalid type of table view cell" format:@"Table view cell type %u is invalid", type];
            break;
    }
    return cell;
}

- (GCButton *)buttonWithType:(GCViewType)type
{
    GCButton *button;
    switch (type) {
        case GCPrimaryButtonType:
            button = [[GCPrimaryButton alloc] init];
            break;
        case GCSecondaryButtonType:
            button = [[GCSecondaryButton alloc] init];
            break;
        default:
            [NSException raise:@"Invalid type of button" format:@"Button type %u is invalid", type];
            break;
    }
    return button;
}

- (GCSwitch *)switchWithType:(GCViewType)type
{
    GCSwitch *switchControl;
    switch (type) {
        case GCSwitchType:
            switchControl = [[GCSwitch alloc] init];
            break;
        default:
            [NSException raise:@"Invalid switch type" format:@"Switch type %u is invalid", type];
            break;
    }
    return switchControl;
}

- (GCTextField *)textFieldWithType:(GCViewType)type
{
    GCTextField *textField;
    switch (type) {
        case GCTextFieldType:
            textField = [[GCTextField alloc] init];
            break;
        case GCIntegerTextFieldType:
            textField = [[GCIntegerTextField alloc] init];
            break;
        case GCFractionalTextFieldType:
            textField = [[GCFractionalTextField alloc] init];
            break;
        default:
            [NSException raise:@"Invalid text field type" format:@"Text field type %u is invalid", type];
            break;
    }
    return textField;
}

- (GCPickerView *)pickerViewWithType:(GCViewType)type
{
    GCPickerView *pickerView;
    switch (type) {
        case GCPickerViewType:
            pickerView = [[GCPickerView alloc] init];
            break;
        default:
            [NSException raise:@"Invalid picker view type" format:@"Picker view type %u is invalid", type];
            break;
    }
    return pickerView;
}

- (GCLabel *)labelWithType:(GCViewType)type
{
    GCLabel *label;
    switch (type) {
        case GCLabelType:
            label = [[GCLabel alloc] init];
            break;
        default:
            [NSException raise:@"Invalid label type" format:@"Label type %u is invalid", type];
            break;
    }
    return label;
}

- (UIView *)tableHeaderViewWithType:(GCViewType)type frame:(CGRect)frame
{
    UIView *view;
    switch (type) {
        case GCSummaryTableHeaderViewType:
            view = [[GCSummaryTableHeaderView alloc] initWithFrame:frame];
            break;
        default:
            [NSException raise:@"Invalid table header view type" format:@"Table header view type %u is invalid", type];
            break;
    }
    return view;
}

@end
