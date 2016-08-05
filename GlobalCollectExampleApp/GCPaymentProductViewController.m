//
//  GCPaymentProductViewController.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 06/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCAppConstants.h"
#import "GCPaymentProductViewController.h"
#import "GCFormRowsConverter.h"
#import "GCFormRow.h"
#import "GCFormRowTextField.h"
#import "GCFormRowCurrency.h"
#import "GCFormRowSwitch.h"
#import "GCFormRowList.h"
#import "GCFormRowButton.h"
#import "GCFormRowLabel.h"
#import "GCFormRowErrorMessage.h"
#import "GCFormRowTooltip.h"
#import "GCButtonTableViewCell.h"
#import "GCSwitchTableViewCell.h"
#import "GCTextFieldTableViewCell.h"
#import "GCCurrencyTableViewCell.h"
#import "GCPickerViewTableViewCell.h"
#import "GCLabelTableViewCell.h"
#import "GCErrorMessageTableViewCell.h"
#import "GCTooltipTableViewCell.h"
#import "GCSummaryTableHeaderView.h"
#import "GCMerchantLogoImageView.h"
#import "GCPaymentAmountOfMoney.h"
#import "GCFormRowCoBrandsSelection.h"
#import "GCIINDetail.h"
#import "GCPaymentProductsTableRow.h"
#import "GCPaymentProductTableViewCell.h"
#import "GCSDKConstants.h"
#import "GCFormRowCoBrandsExplanation.h"
#import "GCCOBrandsExplanationTableViewCell.h"
#import "GCPaymentProductInputData.h"

@interface GCPaymentProductViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) NSMutableArray *formRows;
@property (strong, nonatomic) NSMutableArray *tooltipRows;
@property (nonatomic) BOOL validation;
@property (strong, nonatomic) NSMutableSet *confirmedPaymentProducts;
@property (strong, nonatomic) GCPaymentProductInputData *inputData;
@property (nonatomic) BOOL rememberPaymentDetails;
@property (strong, nonatomic) GCSummaryTableHeaderView *header;
@property (strong, nonatomic) UITextPosition *cursorPositionInCreditCardNumberTextField;
@property (nonatomic) BOOL switching;
@property (nonatomic, strong) GCIINDetailsResponse *iinDetailsResponse;
@property (nonatomic, assign) BOOL coBrandsCollapsed;

@end

@implementation GCPaymentProductViewController

- (instancetype)init

{
    self = [super initWithStyle:UITableViewStylePlain];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([self.tableView respondsToSelector:@selector(setDelaysContentTouches:)] == YES) {
        self.tableView.delaysContentTouches = NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.titleView = [[GCMerchantLogoImageView alloc] init];

    self.rememberPaymentDetails = NO;

    [self initializeHeader];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)] == YES) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self initializeTapRecognizer];
    self.tooltipRows = [[NSMutableArray alloc] init];
    self.validation = NO;
    self.confirmedPaymentProducts = [[NSMutableSet alloc] init];

    self.inputData = [GCPaymentProductInputData new];
    self.inputData.paymentItem = self.paymentItem;
    if ([self.paymentItem isKindOfClass:[GCPaymentProduct class]]) {
        GCPaymentProduct *product = (GCPaymentProduct *) self.paymentItem;
        [self.confirmedPaymentProducts addObject:product.identifier];
    }

    [self initializeFormRows];
    
    self.switching = NO;
    self.coBrandsCollapsed = YES;
}

- (void)initializeTapRecognizer
{
    UITapGestureRecognizer *tapScrollView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapped)];
    tapScrollView.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapScrollView];
}

- (void)tableViewTapped
{
    for (GCFormRow *element in self.formRows) {
        if ([element class] == [GCFormRowTextField class]) {
            GCFormRowTextField *formRowTextField = (GCFormRowTextField *)element;
            if ([formRowTextField.textField isFirstResponder] == YES) {
                [formRowTextField.textField resignFirstResponder];
            }
        } else if ([element class] == [GCFormRowCurrency class]) {
            GCFormRowCurrency *formRowCurrency = (GCFormRowCurrency *)element;
            if ([formRowCurrency.integerTextField isFirstResponder] == YES) {
                [formRowCurrency.integerTextField resignFirstResponder];
            }
            if ([formRowCurrency.fractionalTextField isFirstResponder] == YES) {
                [formRowCurrency.fractionalTextField resignFirstResponder];
            }
        }
    }
}

- (void)initializeHeader
{ 
    self.header = (GCSummaryTableHeaderView *)[self.viewFactory tableHeaderViewWithType:GCSummaryTableHeaderViewType frame:CGRectMake(0, 0, self.tableView.frame.size.width, 80)];
    self.header.summary = [NSString stringWithFormat:@"%@:", NSLocalizedStringFromTable(@"AmountHeaderDescription", kGCAppLocalizable, @"Description of the amount header.")];
    NSNumber *amountAsNumber = [[NSNumber alloc] initWithFloat:self.amount / 100.0];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencyCode:self.context.amountOfMoney.currencyCode];
    NSString *amountAsString = [numberFormatter stringFromNumber:amountAsNumber];
    self.header.amount = amountAsString;
    self.header.securePayment = NSLocalizedStringFromTable(@"SecurePayment", kGCAppLocalizable, @"Text indicating that a secure payment method is used.");
    self.tableView.tableHeaderView = self.header;
}

- (void)initializeFormRows
{
    [self updateFormRowsWithValidation:self.validation tooltipRows:self.tooltipRows confirmedPaymentProducts:self.confirmedPaymentProducts];
}

- (void)updateFormRowsWithValidation:(BOOL)validation tooltipRows:(NSArray *)tooltipRows confirmedPaymentProducts:(NSSet *)confirmedPaymentProducts
{
    GCFormRowsConverter *mapper = [[GCFormRowsConverter alloc] init];
    NSArray *formRows = [mapper formRowsFromInputData:self.inputData iinDetailsResponse:self.iinDetailsResponse validation:validation viewFactory:self.viewFactory confirmedPaymentProducts:confirmedPaymentProducts];

    NSMutableArray *formRowsWithTooltip = [[NSMutableArray alloc] init];
    for (GCFormRow *row in formRows) {
        [formRowsWithTooltip addObject:row];
        if ([row class] == [GCFormRowTextField class]) {
            GCFormRowTextField *textFieldRow = (GCFormRowTextField *)row;

            if ([textFieldRow.paymentProductField.identifier isEqualToString:@"cardNumber"]) {
                [self addCoBrandFormsInFormRows:formRowsWithTooltip iinDetailsResponse:self.iinDetailsResponse];
            }

            for (GCFormRowTooltip *tooltipRow in tooltipRows) {
                if (tooltipRow.paymentProductField == textFieldRow.paymentProductField) {
                    [formRowsWithTooltip addObject:tooltipRow];
                }
            }
        }
    }
    
    self.formRows = formRowsWithTooltip;

    if ([self.paymentItem isKindOfClass:[GCPaymentProduct class]]) {
        GCPaymentProduct *product = (GCPaymentProduct *) self.paymentItem;
        if (product.allowsTokenization == YES && product.autoTokenized == NO && self.accountOnFile == nil) {
            GCFormRowSwitch *switchFormRow = [[GCFormRowSwitch alloc] init];
            switchFormRow.switchControl = (GCSwitch *) [self.viewFactory switchWithType:GCSwitchType];
            switchFormRow.text = NSLocalizedStringFromTable(@"RememberMyDetails", kGCAppLocalizable, @"Explanation of the switch for remembering payment information.");
            switchFormRow.switchControl.on = self.rememberPaymentDetails;
            [self.formRows addObject:switchFormRow];
        }
    }
    
    GCFormRowButton *payButtonFormRow = [[GCFormRowButton alloc] init];
    NSString *payButtonTitle = NSLocalizedStringFromTable(@"Pay", kGCAppLocalizable, @"Title of the pay button on the payment product screen.");
    UIButton* payButton = [self.viewFactory buttonWithType:GCPrimaryButtonType];
    [payButton setTitle:payButtonTitle forState:UIControlStateNormal];
    [payButton addTarget:self action:@selector(payButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    payButtonFormRow.button = payButton;
    [self.formRows addObject:payButtonFormRow];
    
    GCFormRowButton *cancelButtonFormRow = [[GCFormRowButton alloc] init];
    NSString *cancelButtonTitle = NSLocalizedStringFromTable(@"Cancel", kGCAppLocalizable, @"Title of the cancel button on the payment product screen.");
    UIButton* cancelButton = [self.viewFactory buttonWithType:GCSecondaryButtonType];
    [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    cancelButtonFormRow.button = cancelButton;
    [self.formRows addObject:cancelButtonFormRow];
}

- (void)addCoBrandFormsInFormRows:(NSMutableArray *)formRows iinDetailsResponse:(GCIINDetailsResponse *)iinDetailsResponse {
    NSMutableArray *coBrands = [NSMutableArray new];
    for (GCIINDetail *coBrand in iinDetailsResponse.coBrands) {
        if (coBrand.isAllowedInContext) {
            [coBrands addObject:coBrand.paymentProductId];
        }
    }
    if (coBrands.count > 1) {
        if (!self.coBrandsCollapsed) {
            NSString *sdkBundlePath = [[NSBundle mainBundle] pathForResource:@"GlobalCollectSDK" ofType:@"bundle"];
            NSBundle *sdkBundle = [NSBundle bundleWithPath:sdkBundlePath];

            //Add explanation row
            GCFormRowCoBrandsExplanation *explanationRow = [GCFormRowCoBrandsExplanation new];
            [formRows addObject:explanationRow];

            //Add row for selection coBrands
            for (NSString *id in coBrands) {
                GCPaymentProductsTableRow *row = [[GCPaymentProductsTableRow alloc] init];
                row.paymentProductIdentifier = id;

                NSString *paymentProductKey = [NSString stringWithFormat:@"gc.general.paymentProducts.%@.name", id];
                NSString *paymentProductValue = NSLocalizedStringFromTableInBundle(paymentProductKey, kGCSDKLocalizable, sdkBundle, nil);
                row.name = paymentProductValue;

                GCAssetManager *assetManager = [GCAssetManager new];
                UIImage *logo = [assetManager logoImageForPaymentItem:id];
                row.logo = logo;

                [formRows addObject:row];
            }
        }

        GCFormRowCoBrandsSelection *toggleCoBrandRow = [GCFormRowCoBrandsSelection new];
        [formRows addObject:toggleCoBrandRow];
    }
}

-(void)switchToPaymentProduct:(NSString *)paymentProductId {
    if (paymentProductId != nil) {
        [self.confirmedPaymentProducts addObject:paymentProductId];
    }
    if (paymentProductId == nil) {
        if ([self.confirmedPaymentProducts containsObject:self.paymentItem.identifier]) {
            [self.confirmedPaymentProducts removeObject:self.paymentItem.identifier];
        }
        [self updateFormRows];
    }
    else if ([paymentProductId isEqualToString:self.paymentItem.identifier] == YES) {
        [self updateFormRows];
    }
    else if (self.switching == NO) {
        self.switching = YES;
        [self.session paymentProductWithId:paymentProductId context:self.context success:^(GCPaymentProduct *paymentProduct) {
            self.paymentItem = paymentProduct;
            self.inputData.paymentItem = paymentProduct;
            [self updateFormRows];
            self.switching = NO;
        } failure:^(NSError *error) {
        }];
    }
}

-(void)updateFormRows {
    self.coBrandsCollapsed = YES;
    [self updateFormRowsWithValidation:NO tooltipRows:self.tooltipRows confirmedPaymentProducts:self.confirmedPaymentProducts];
    [self.tableView reloadData];
    [self resetCardNumberTextField];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.formRows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCFormRow *row = self.formRows[indexPath.row];
    Class class = [row class];
    GCTableViewCell *cell;
    if (class == [GCFormRowTextField class]) {
        cell = [self cellForTextField:(GCFormRowTextField *)row tableView:tableView];
    } else if (class == [GCFormRowCurrency class]) {
        cell = [self cellForCurrency:(GCFormRowCurrency *) row tableView:tableView];
    } else if (class == [GCFormRowSwitch class]) {
        cell = [self cellForSwitch:(GCFormRowSwitch *)row tableView:tableView];
    } else if (class == [GCFormRowList class]) {
        cell = [self cellForList:(GCFormRowList *)row tableView:tableView];
    } else if (class == [GCFormRowButton class]) {
        cell = [self cellForButton:(GCFormRowButton *)row tableView:tableView];
    } else if (class == [GCFormRowLabel class]) {
        cell = [self cellForLabel:(GCFormRowLabel *)row tableView:tableView];
    } else if (class == [GCFormRowErrorMessage class]) {
        cell = [self cellForErrorMessage:(GCFormRowErrorMessage *)row tableView:tableView];
    } else if (class == [GCFormRowTooltip class]) {
        cell = [self cellForTooltip:(GCFormRowTooltip *)row tableView:tableView];
    } else if (class == [GCFormRowCoBrandsSelection class]) {
        cell = [self cellForCoBrandsSelection:(GCFormRowCoBrandsSelection *)row tableView:tableView];
    } else if (class == [GCFormRowCoBrandsExplanation class]) {
        cell = [self cellForCoBrandsExplanation:(GCFormRowCoBrandsExplanation  *)row tableView:tableView];
    } else if (class == [GCPaymentProductsTableRow class]) {
        cell = [self cellForPaymentProduct:(GCPaymentProductsTableRow  *)row tableView:tableView];
    } else {
        [NSException raise:@"Invalid form row class" format:@"Form row class %@ is invalid", class];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Helper methods for data source methods

- (GCTextFieldTableViewCell *)cellForTextField:(GCFormRowTextField *)row tableView:(UITableView *)tableView
{
    NSString *reuseIdentifier = @"text-field-cell";
    GCTextFieldTableViewCell *cell = (GCTextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = (GCTextFieldTableViewCell *)[self.viewFactory tableViewCellWithType:GCTextFieldTableViewCellType reuseIdentifier:reuseIdentifier];
    }
    cell.textField = row.textField;
    cell.textField.delegate = self;
    if (row.showInfoButton == YES) {
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (GCCurrencyTableViewCell *)cellForCurrency:(GCFormRowCurrency *)row tableView:(UITableView *)tableView
{
    NSString *reuseIdentifier = @"currency-text-field-cell";
    GCCurrencyTableViewCell *cell = (GCCurrencyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = (GCCurrencyTableViewCell *)[self.viewFactory tableViewCellWithType:GCCurrencyTableViewCellType reuseIdentifier:reuseIdentifier];
    }
    cell.integerTextField = row.integerTextField;
    cell.integerTextField.delegate = self;
    cell.fractionalTextField = row.fractionalTextField;
    cell.fractionalTextField.delegate = self;
    cell.currencyCode = self.context.amountOfMoney.currencyCode;
    if (row.showInfoButton == YES) {
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (GCSwitchTableViewCell *)cellForSwitch:(GCFormRowSwitch *)row tableView:(UITableView *)tableView
{
    NSString *reuseIdentifier = @"switch-cell";
    GCSwitchTableViewCell *cell = (GCSwitchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = (GCSwitchTableViewCell *)[self.viewFactory tableViewCellWithType:GCSwitchTableViewCellType reuseIdentifier:reuseIdentifier];
    }
    cell.switchControl = row.switchControl;
    cell.textLabel.text = row.text;
    [cell.switchControl addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    return cell;
}

- (GCPickerViewTableViewCell *)cellForList:(GCFormRowList *)row tableView:(UITableView *)tableView
{
    NSString *reuseIdentifier = @"picker-view-cell";
    GCPickerViewTableViewCell *cell = (GCPickerViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = (GCPickerViewTableViewCell *)[self.viewFactory tableViewCellWithType:GCPickerViewTableViewCellType reuseIdentifier:reuseIdentifier];
    }
    cell.pickerView = row.pickerView;
    cell.pickerView.delegate = self;
    cell.pickerView.dataSource = self;
    [cell.pickerView selectRow:row.selectedRow inComponent:0 animated:NO];
    return cell;
}

- (GCButtonTableViewCell *)cellForButton:(GCFormRowButton *)row tableView:(UITableView *)tableView
{
    NSString *reuseIdentifier = @"button-cell";
    GCButtonTableViewCell *cell = (GCButtonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = (GCButtonTableViewCell *)[self.viewFactory tableViewCellWithType:GCButtonTableViewCellType reuseIdentifier:reuseIdentifier];
    }
    cell.button = row.button;
    return cell;
}

- (GCLabelTableViewCell *)cellForLabel:(GCFormRowLabel *)row tableView:(UITableView *)tableView
{
    NSString *reuseIdentifier = @"label-cell";
    GCLabelTableViewCell *cell = (GCLabelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = (GCLabelTableViewCell *)[self.viewFactory tableViewCellWithType:GCLabelTableViewCellType reuseIdentifier:reuseIdentifier];
    }
    cell.label = row.label;
    return cell;
}

- (GCErrorMessageTableViewCell *)cellForErrorMessage:(GCFormRowErrorMessage *)row tableView:(UITableView *)tableView
{
    NSString *reuseIdentifier = @"error-cell";
    GCErrorMessageTableViewCell *cell = (GCErrorMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = (GCErrorMessageTableViewCell *)[self.viewFactory tableViewCellWithType:GCErrorMessageTableViewCellType reuseIdentifier:reuseIdentifier];
    }
    cell.textLabel.text = row.errorMessage;
    return cell;
}

- (GCTooltipTableViewCell *)cellForTooltip:(GCFormRowTooltip *)row tableView:(UITableView *)tableView
{
    NSString *reuseIdentifier = @"info-cell";
    GCTooltipTableViewCell *cell = (GCTooltipTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = (GCTooltipTableViewCell *)[self.viewFactory tableViewCellWithType:GCTooltipTableViewCellType reuseIdentifier:reuseIdentifier];
    }
    cell.tooltipLabel.text = row.tooltipText;
    cell.tooltipImage = row.tooltipImage;
    return cell;
}

- (GCCoBrandsSelectionTableViewCell *)cellForCoBrandsSelection:(GCFormRowCoBrandsSelection *)row tableView:(UITableView *)tableView
{
    NSString *reuseIdentifier = @"co-brand-selection-cell";
    GCCoBrandsSelectionTableViewCell *cell = (GCCoBrandsSelectionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = (GCCoBrandsSelectionTableViewCell *)[self.viewFactory tableViewCellWithType:GCCoBrandsSelectionTableViewCellType reuseIdentifier:reuseIdentifier];
    }
    return cell;
}


- (GCCOBrandsExplanationTableViewCell *)cellForCoBrandsExplanation:(GCFormRowCoBrandsExplanation *)row tableView:(UITableView *)tableView
{
    NSString *reuseIdentifier = @"co-brand-explanation-cell";
    GCCOBrandsExplanationTableViewCell *cell = (GCCOBrandsExplanationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = (GCCOBrandsExplanationTableViewCell *)[self.viewFactory tableViewCellWithType:GCCoBrandsExplanationTableViewCellType reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (GCPaymentProductTableViewCell *)cellForPaymentProduct:(GCPaymentProductsTableRow *)row tableView:(UITableView *)tableView
{
    NSString *reuseIdentifier = @"payment-product-selection-cell";
    GCPaymentProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = (GCPaymentProductTableViewCell *)[self.viewFactory tableViewCellWithType:GCPaymentProductTableViewCellType reuseIdentifier:reuseIdentifier];
    }
    cell.name = row.name;
    cell.logo = row.logo;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [cell setNeedsLayout];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCFormRow *row = self.formRows[indexPath.row];
    Class class = [row class];
    if (class == [GCFormRowList class]) {
        return 162.5;
    } else if (class == [GCFormRowTooltip class]) {
        return 160;
    } else if (class == [GCFormRowCoBrandsSelection class]) {
        return 30;
    } else if (class == [GCFormRowCoBrandsExplanation class]) {
        NSAttributedString *cellString = [GCCOBrandsExplanationTableViewCell cellString];
        CGRect rect = [cellString boundingRectWithSize:CGSizeMake(tableView.bounds.size.width, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
        return rect.size.height + 20;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.formRows[indexPath.row] isKindOfClass:[GCFormRowCoBrandsSelection class]]) {
        self.coBrandsCollapsed = !self.coBrandsCollapsed;
        [self updateFormRowsWithValidation:self.validation tooltipRows:self.tooltipRows confirmedPaymentProducts:self.confirmedPaymentProducts];
        [self.tableView reloadData];
    } else if ([self.formRows[indexPath.row] isKindOfClass:[GCPaymentProductsTableRow class]]) {
        GCPaymentProductsTableRow *row = (GCPaymentProductsTableRow *)self.formRows[indexPath.row];
        [self switchToPaymentProduct:row.paymentProductIdentifier];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    GCTextFieldTableViewCell *cell = (GCTextFieldTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    GCFormRowTextField *textFieldRow = [self formRowWithTextField:cell.textField];
    
    NSMutableArray *newTooltipRows = [[NSMutableArray alloc] init];
    BOOL found = NO;
    for (GCFormRowTooltip *tooltipRow in self.tooltipRows) {
        if (tooltipRow.paymentProductField != textFieldRow.paymentProductField) {
            [newTooltipRows addObject:tooltipRow];
        } else {
            found = YES;
        }
    }
    if (found == NO) {
        GCFormRowTooltip *tooltipRow = [[GCFormRowTooltip alloc] init];
        tooltipRow.paymentProductField = textFieldRow.paymentProductField;
        tooltipRow.tooltipImage = textFieldRow.tooltipImage;
        tooltipRow.tooltipText = textFieldRow.tooltipText;
        [newTooltipRows addObject:tooltipRow];
    }
    self.tooltipRows = newTooltipRows;
    [self updateFormRowsWithValidation:self.validation tooltipRows:self.tooltipRows confirmedPaymentProducts:self.confirmedPaymentProducts];
    [self.tableView reloadData];
}

#pragma mark TextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL result;
    if ([textField class] == [GCTextField class]) {
        result = [self standardTextField:(GCTextField *)textField shouldChangeCharactersInRange:range replacementString:string];
    } else if ([textField class] == [GCIntegerTextField class]) {
        result = [self integerTextField:(GCIntegerTextField *)textField shouldChangeCharactersInRange:range replacementString:string];
    } else if ([textField class] == [GCFractionalTextField class]) {
        result = [self fractionalTextField:(GCFractionalTextField *)textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return result;
}

- (BOOL)standardTextField:(GCTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    GCFormRowTextField *row = [self formRowWithTextField:textField];
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self.inputData setValue:newString forField:row.paymentProductField.identifier];
    if (string.length == 0) {
        return YES;
    } else {
        NSInteger cursorPosition = range.location + string.length;
        NSString *formattedString = [self.inputData maskedValueForField:row.paymentProductField.identifier cursorPosition:&cursorPosition];
        textField.text = formattedString;
        cursorPosition = MIN(cursorPosition, formattedString.length);
        UITextPosition *cursorPositionInTextField = [textField positionFromPosition:textField.beginningOfDocument offset:cursorPosition];
        [textField setSelectedTextRange:[textField textRangeFromPosition:cursorPositionInTextField toPosition:cursorPositionInTextField]];
        
        if ([row.paymentProductField.identifier isEqualToString:@"cardNumber"] == YES) {
            NSString *unmasked = [self.inputData unmaskedValueForField:row.paymentProductField.identifier];
            if (unmasked.length >= 6) {
                unmasked = [unmasked substringToIndex:6];

                [self.session IINDetailsForPartialCreditCardNumber:unmasked context:self.context success:^(GCIINDetailsResponse *response) {
                    self.iinDetailsResponse = response;
                    if (response.status == GCSupported) {
                        BOOL coBrandSelected = NO;
                        for (GCIINDetail *coBrand in response.coBrands) {
                            if ([coBrand.paymentProductId isEqualToString:self.paymentItem.identifier]) {
                                coBrandSelected = YES;
                            }
                        }
                        if (coBrandSelected == NO) {
                            [self switchToPaymentProduct:response.paymentProductId];
                        }
                        else {
                            [self switchToPaymentProduct:self.paymentItem.identifier];
                        }
                    }
                    else {
                        [self switchToPaymentProduct:nil];
                    }
                }                                          failure:^(NSError *error) {
                }];
            }
        }
        return NO;
    }
}

- (BOOL)integerTextField:(GCIntegerTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    GCFormRowCurrency *row = [self formRowWithIntegerTextField:textField];
    NSString *integerString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *fractionalString = row.fractionalTextField.text;

    if (integerString.length > 16) {
        return NO;
    }

    NSString *newValue = [self updateCurrencyValueWithIntegerString:integerString fractionalString:fractionalString paymentProductFieldIdentifier:row.paymentProductField.identifier];
    if (string.length == 0) {
        return YES;
    } else {
        [self updateRowWithCurrencyValue:newValue formRowCurrency:row];
        return NO;
    }
}

- (BOOL)fractionalTextField:(GCFractionalTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    GCFormRowCurrency *row = [self formRowWithFractionalTextField:textField];
    NSString *integerString = row.integerTextField.text;
    NSString *fractionalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (fractionalString.length > 2) {
        int start = (int) fractionalString.length - 2;
        int end = (int) fractionalString.length - 1;
        fractionalString = [fractionalString substringWithRange:NSMakeRange(start, end)];
    }
    
    NSString *newValue = [self updateCurrencyValueWithIntegerString:integerString fractionalString:fractionalString paymentProductFieldIdentifier:row.paymentProductField.identifier];
    if (string.length == 0) {
        return YES;
    } else {
        [self updateRowWithCurrencyValue:newValue formRowCurrency:row];
        return NO;
    }
}

- (NSString *)updateCurrencyValueWithIntegerString:(NSString *)integerString fractionalString:(NSString *)fractionalString paymentProductFieldIdentifier:(NSString *)identifier
{
    long long integerPart = [integerString longLongValue];
    int fractionalPart = [fractionalString intValue];
    long long newValue = integerPart * 100 + fractionalPart;
    NSString *newString = [NSString stringWithFormat:@"%03lld", newValue];
    [self.inputData setValue:newString forField:identifier];
    
    return newString;
}

- (void)updateRowWithCurrencyValue:(NSString *)currencyValue formRowCurrency:(GCFormRowCurrency *)formRowCurrency
{
    formRowCurrency.integerTextField.text = [currencyValue substringToIndex:currencyValue.length - 2];
    formRowCurrency.fractionalTextField.text = [currencyValue substringFromIndex:currencyValue.length - 2];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return NO;
}

#pragma mark TextField delegate helper methods

- (void)resetCardNumberTextField
{
    for (GCFormRow *row in self.formRows) {
        if ([row class] == [GCFormRowTextField class]) {
            GCFormRowTextField *textFieldRow = (GCFormRowTextField *)row;
            if ([textFieldRow.paymentProductField.identifier isEqualToString:@"cardNumber"] == YES) {
                textFieldRow.textField.rightView = textFieldRow.logo;
                GCTextField *textField = textFieldRow.textField;
                [textField setSelectedTextRange:[textField textRangeFromPosition:self.cursorPositionInCreditCardNumberTextField toPosition:self.cursorPositionInCreditCardNumberTextField]];
                [textField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.1f];
            }
        }
    }
}

#pragma mark Picker view delegate

- (NSInteger)numberOfComponentsInPickerView:(GCPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(GCPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerView.content.count;
}

- (NSAttributedString *)pickerView:(GCPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *item = pickerView.content[row];
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:item];
    return string;
}

- (void)pickerView:(GCPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    GCFormRowList *element = [self formRowWithPickerView:pickerView];
    NSString *name = pickerView.content[row];
    NSString *identifier = [element.nameToIdentifierMapping objectForKey:name];
    element.selectedRow = row;
    [self.inputData setValue:identifier forField:element.paymentProductFieldIdentifier];
}

#pragma mark Button target methods

- (void)payButtonTapped
{
    BOOL valid = NO;

    [self.inputData validate];
    if (self.inputData.errors.count == 0) {
        GCPaymentRequest *paymentRequest = [self.inputData paymentRequest];
        [paymentRequest validate];
        if (paymentRequest.errors.count == 0) {
            valid = YES;
            [self.paymentRequestTarget didSubmitPaymentRequest:paymentRequest];
        }
    }
    if (valid == NO) {
        self.validation = YES;
        [self updateFormRowsWithValidation:self.validation tooltipRows:self.tooltipRows confirmedPaymentProducts:self.confirmedPaymentProducts];
        [self.tableView reloadData];
    }

}

- (void)cancelButtonTapped
{
    [self.paymentRequestTarget didCancelPaymentRequest];
}

- (void)switchChanged:(GCSwitch *)sender
{
    self.inputData.tokenize = sender.on;
}

#pragma mark Helper methods

- (GCFormRowTextField *)formRowWithTextField:(GCTextField *)textField
{
    for (GCFormRow *row in self.formRows) {
        if ([row class] == [GCFormRowTextField class]) {
            GCFormRowTextField *textFieldRow = (GCFormRowTextField *)row;
            if (textFieldRow.textField == textField) {
                return textFieldRow;
            }
        }
    }
    return nil;
}

- (GCFormRowCurrency *)formRowWithIntegerTextField:(GCIntegerTextField *)integerTextField
{
    for (GCFormRow *row in self.formRows) {
        if ([row class] == [GCFormRowCurrency class]) {
            GCFormRowCurrency *currencyRow = (GCFormRowCurrency *)row;
            if (currencyRow.integerTextField == integerTextField) {
                return currencyRow;
            }
        }
    }
    return nil;
}

- (GCFormRowCurrency *)formRowWithFractionalTextField:(GCFractionalTextField *)fractionalTextField
{
    for (GCFormRow *row in self.formRows) {
        if ([row class] == [GCFormRowCurrency class]) {
            GCFormRowCurrency *currencyRow = (GCFormRowCurrency *)row;
            if (currencyRow.fractionalTextField == fractionalTextField) {
                return currencyRow;
            }
        }
    }
    return nil;
}

- (GCFormRowList *)formRowWithPickerView:(UIPickerView *)pickerView
{
    for (GCFormRow *row in self.formRows) {
        if ([row class] == [GCFormRowList class]) {
            GCFormRowList *listRow = (GCFormRowList *)row;
            if (listRow.pickerView == pickerView) {
                return listRow;
            }
        }
    }
    return nil;
}


@end
