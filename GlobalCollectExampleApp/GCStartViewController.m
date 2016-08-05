//
//  GCStartViewController.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 01/05/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>

#import "GCAppConstants.h"
#import "GCSDKConstants.h"
#import "GCPaymentItem.h"
#import "GCStartViewController.h"
#import "GCViewFactory.h"
#import "GCPaymentProductsViewController.h"
#import "GCPaymentProductViewController.h"
#import "GCEndViewController.h"

#import "GCPaymentAmountOfMoney.h"
#import "GCPaymentProductGroup.h"
#import "GCBasicPaymentProductGroup.h"

@interface GCStartViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UITextView *explanation;
@property (strong, nonatomic) GCLabel *clientSessionIdLabel;
@property (strong, nonatomic) GCTextField *clientSessionIdTextField;
@property (strong, nonatomic) GCLabel *customerIdLabel;
@property (strong, nonatomic) GCTextField *customerIdTextField;
@property (strong, nonatomic) GCLabel *regionLabel;
@property (strong, nonatomic) UISegmentedControl *regionControl;
@property (strong, nonatomic) GCLabel *environmentLabel;
@property (strong, nonatomic) GCPickerView *environmentPicker;
@property (strong, nonatomic) GCLabel *amountLabel;
@property (strong, nonatomic) GCTextField *amountTextField;
@property (strong, nonatomic) GCLabel *countryCodeLabel;
@property (strong, nonatomic) GCPickerView *countryCodePicker;
@property (strong, nonatomic) GCLabel *currencyCodeLabel;
@property (strong, nonatomic) GCPickerView *currencyCodePicker;
@property (strong, nonatomic) GCLabel *isRecurringLabel;
@property (strong, nonatomic) GCSwitch *isRecurringSwitch;
@property (strong, nonatomic) UIButton *payButton;

@property (nonatomic) long amountValue;

@property (strong, nonatomic) GCViewFactory *viewFactory;
@property (strong, nonatomic) GCSession *session;
@property (strong, nonatomic) GCPaymentContext *context;

@property (strong, nonatomic) NSArray *countryCodes;
@property (strong, nonatomic) NSArray *currencyCodes;

@end

@implementation GCStartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeTapRecognizer];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)] == YES) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.viewFactory = [[GCViewFactory alloc] init];
    
    self.countryCodes = [[kGCCountryCodes componentsSeparatedByString:@", "] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    self.currencyCodes = [[kGCCurrencyCodes componentsSeparatedByString:@", "] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSInteger viewHeight = 1420;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.delaysContentTouches = NO;
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, viewHeight);
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.scrollView];
    
    UIView *superContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, viewHeight)];
    superContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.scrollView addSubview:superContainerView];
    
    self.containerView = [[UIView alloc] init];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [superContainerView addSubview:self.containerView];

    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:viewHeight];
    [self.containerView addConstraint:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:320];
    [self.containerView addConstraint:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superContainerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [superContainerView addConstraint:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superContainerView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [superContainerView addConstraint:constraint];

    self.explanation = [[UITextView alloc] init];
    self.explanation.translatesAutoresizingMaskIntoConstraints = NO;
    self.explanation.text = NSLocalizedStringFromTable(@"SetupExplanation", kGCAppLocalizable, @"To process a payment using the services provided by the GlobalCollect platform, the following information must be provided by a merchant.\n\nAfter providing the information requested below, this example app can process a payment.");
    self.explanation.editable = NO;
    self.explanation.backgroundColor = [UIColor colorWithRed:0.85 green:0.94 blue:0.97 alpha:1];
    self.explanation.textColor = [UIColor colorWithRed:0 green:0.58 blue:0.82 alpha:1];
    self.explanation.layer.cornerRadius = 5.0;
    [self.containerView addSubview:self.explanation];

    self.clientSessionIdLabel = [self.viewFactory labelWithType:GCLabelType];
    self.clientSessionIdLabel.text = NSLocalizedStringFromTable(@"ClientSessionIdentifier", kGCAppLocalizable, @"Client session identifier");
    self.clientSessionIdLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.clientSessionIdTextField = [self.viewFactory textFieldWithType:GCTextFieldType];
    self.clientSessionIdTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.clientSessionIdTextField.text = [StandardUserDefaults objectForKey:kGCClientSessionId];
    [self.containerView addSubview:self.clientSessionIdLabel];
    [self.containerView addSubview:self.clientSessionIdTextField];
    
    self.customerIdLabel = [self.viewFactory labelWithType:GCLabelType];
    self.customerIdLabel.text = NSLocalizedStringFromTable(@"CustomerIdentifier", kGCAppLocalizable, @"Customer identifier");
    self.customerIdLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.customerIdTextField = [self.viewFactory textFieldWithType:GCTextFieldType];
    self.customerIdTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.customerIdTextField.text = [StandardUserDefaults objectForKey:kGCCustomerId];
    [self.containerView addSubview:self.customerIdLabel];
    [self.containerView addSubview:self.customerIdTextField];

    self.regionLabel = [self.viewFactory labelWithType:GCLabelType];
    self.regionLabel.text = NSLocalizedStringFromTable(@"Region", kGCAppLocalizable, @"Region");
    self.regionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.regionControl = [[UISegmentedControl alloc] initWithItems:@[@"EU", @"US"]];
    self.regionControl.selectedSegmentIndex = 0;
    self.regionControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.regionLabel];
    [self.containerView addSubview:self.regionControl];
    
    self.environmentLabel = [self.viewFactory labelWithType:GCLabelType];
    self.environmentLabel.text = NSLocalizedStringFromTable(@"Environment", kGCAppLocalizable, @"Environment");
    self.environmentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.environmentPicker = [self.viewFactory pickerViewWithType:GCPickerViewType];
    self.environmentPicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.environmentPicker.content = @[@"Production", @"Pre-production", @"Sandbox"];
    self.environmentPicker.dataSource = self;
    self.environmentPicker.delegate = self;
    [self.environmentPicker selectRow:2 inComponent:0 animated:NO];
    [self.containerView addSubview:self.environmentLabel];
    [self.containerView addSubview:self.environmentPicker];
    
    self.amountLabel = [self.viewFactory labelWithType:GCLabelType];
    self.amountLabel.text = NSLocalizedStringFromTable(@"AmountInCents", kGCAppLocalizable, @"Amount in cents");
    self.amountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.amountTextField = [self.viewFactory textFieldWithType:GCTextFieldType];
    self.amountTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.amountTextField.text = @"100";
    [self.containerView addSubview:self.amountLabel];
    [self.containerView addSubview:self.amountTextField];
    
    self.countryCodeLabel = [self.viewFactory labelWithType:GCLabelType];
    self.countryCodeLabel.text = NSLocalizedStringFromTable(@"CountryCode", kGCAppLocalizable, @"Country code");
    self.countryCodeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.countryCodePicker = [self.viewFactory pickerViewWithType:GCPickerViewType];
    self.countryCodePicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.countryCodePicker.content = self.countryCodes;
    self.countryCodePicker.dataSource = self;
    self.countryCodePicker.delegate = self;
    [self.countryCodePicker selectRow:165 inComponent:0 animated:NO];
    [self.containerView addSubview:self.countryCodeLabel];
    [self.containerView addSubview:self.countryCodePicker];
    
    self.currencyCodeLabel = [self.viewFactory labelWithType:GCLabelType];
    self.currencyCodeLabel.text = NSLocalizedStringFromTable(@"CurrencyCode", kGCAppLocalizable, @"Currency code");
    self.currencyCodeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.currencyCodePicker = [self.viewFactory pickerViewWithType:GCPickerViewType];
    self.currencyCodePicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.currencyCodePicker.content = self.currencyCodes;
    self.currencyCodePicker.dataSource = self;
    self.currencyCodePicker.delegate = self;
    [self.currencyCodePicker selectRow:42 inComponent:0 animated:NO];
    [self.containerView addSubview:self.currencyCodeLabel];
    [self.containerView addSubview:self.currencyCodePicker];
    
    self.isRecurringLabel = [self.viewFactory labelWithType:GCLabelType];
    self.isRecurringLabel.text = NSLocalizedStringFromTable(@"RecurringPayment", kGCAppLocalizable, @"Payment is recurring");
    self.isRecurringLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.isRecurringSwitch = [self.viewFactory switchWithType:GCSwitchType];
    self.isRecurringSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.isRecurringLabel];
    [self.containerView addSubview:self.isRecurringSwitch];

    self.payButton = [self.viewFactory buttonWithType:GCPrimaryButtonType];
    [self.payButton setTitle:NSLocalizedStringFromTable(@"PayNow", kGCAppLocalizable, @"Pay securely now") forState:UIControlStateNormal];
    self.payButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.payButton addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.payButton];

    NSDictionary *views = NSDictionaryOfVariableBindings(_explanation, _clientSessionIdLabel, _clientSessionIdTextField, _customerIdLabel, _customerIdTextField, _regionLabel, _regionControl, _environmentLabel, _environmentPicker, _amountLabel, _amountTextField, _countryCodeLabel, _countryCodePicker, _currencyCodeLabel, _currencyCodePicker, _isRecurringLabel, _isRecurringSwitch, _payButton);
    NSDictionary *metrics = @{@"largeSpace": @"24"};

    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_explanation]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_clientSessionIdLabel]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_clientSessionIdTextField]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_customerIdLabel]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_customerIdTextField]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_regionLabel]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_regionControl]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_environmentLabel]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_environmentPicker]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_amountLabel]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_amountTextField]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_countryCodeLabel]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_countryCodePicker]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_currencyCodeLabel]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_currencyCodePicker]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_isRecurringLabel]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_isRecurringSwitch]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_payButton]-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(largeSpace)-[_explanation(==100)]-(largeSpace)-[_clientSessionIdLabel]-[_clientSessionIdTextField]-(largeSpace)-[_customerIdLabel]-[_customerIdTextField]-(largeSpace)-[_regionLabel]-[_regionControl]-(largeSpace)-[_environmentLabel]-[_environmentPicker]-(largeSpace)-[_amountLabel]-[_amountTextField]-(largeSpace)-[_countryCodeLabel]-[_countryCodePicker]-(largeSpace)-[_currencyCodeLabel]-[_currencyCodePicker]-(largeSpace)-[_isRecurringLabel]-[_isRecurringSwitch]-(largeSpace)-[_payButton]" options:0 metrics:metrics views:views]];
}

- (void)initializeTapRecognizer
{
    UITapGestureRecognizer *tapScrollView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapped)];
    tapScrollView.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapScrollView];
}

- (void)tableViewTapped
{
    for (UIView *view in self.containerView.subviews) {
        if ([view class] == [GCTextField class]) {
            GCTextField *textField = (GCTextField *)view;
            if ([textField isFirstResponder] == YES) {
                [textField resignFirstResponder];
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

- (void)buyButtonTapped:(UIButton *)sender
{
    if (self.payButton == sender) {
        self.amountValue = (long) [self.amountTextField.text longLongValue];
    } else {
        [NSException raise:@"Invalid sender" format:@"Sender %@ is invalid", sender];
    }

    [SVProgressHUD show];

    NSString *clientSessionId = self.clientSessionIdTextField.text;
    [StandardUserDefaults setObject:clientSessionId forKey:kGCClientSessionId];
    NSString *customerId = self.customerIdTextField.text;
    [StandardUserDefaults setObject:customerId forKey:kGCCustomerId];
    GCRegion region;
    if (self.regionControl.selectedSegmentIndex == 0) {
        region = GCRegionEU;
    } else {
        region = GCRegionUS;
    }
    GCEnvironment environment = (GCEnvironment) [self.environmentPicker selectedRowInComponent:0];

    // ***************************************************************************
    //
    // The GlobalCollect SDK supports processing payments with instances of the
    // GCSession class. The code below shows how such an instance chould be
    // instantiated.
    //
    // The GCSession class uses a number of supporting objects. There is an
    // initializer for this class that takes these supporting objects as
    // arguments. This should make it easy to replace these additional objects
    // without changing the implementation of the SDK. Use this initializer
    // instead of the factory method used below if you want to replace any of the
    // supporting objects.
    //
    // ***************************************************************************

    self.session = [GCSession sessionWithClientSessionId:clientSessionId customerId:customerId region:region environment:environment];

    NSString *countryCode = [self.countryCodes objectAtIndex:[self.countryCodePicker selectedRowInComponent:0]];
    NSString *currencyCode = [self.currencyCodes objectAtIndex:[self.currencyCodePicker selectedRowInComponent:0]];
    BOOL isRecurring = self.isRecurringSwitch.on;

    // ***************************************************************************
    //
    // To retrieve the available payment products, the information stored in the
    // following GCPaymentContext object is needed.
    //
    // After the GCSession object has retrieved the payment products that match
    // the information stored in the GCPaymentContext object, a
    // selection screen is shown. This screen itself is not part of the SDK and
    // only illustrates a possible payment product selection screen.
    //
    // ***************************************************************************
    GCPaymentAmountOfMoney *amountOfMoney = [[GCPaymentAmountOfMoney alloc] initWithTotalAmount:self.amountValue currencyCode:currencyCode];
    self.context = [[GCPaymentContext alloc] initWithAmountOfMoney:amountOfMoney isRecurring:isRecurring countryCode:countryCode];

    [self.session paymentItemsForContext:self.context groupPaymentProducts:YES success:^(GCPaymentItems *paymentItems) {
        [SVProgressHUD dismiss];
        [self showPaymentProductSelection:paymentItems];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"ConnectionErrorTitle", kGCAppLocalizable, @"Title of the connection error dialog.") message:NSLocalizedStringFromTable(@"PaymentProductsErrorExplanation", kGCAppLocalizable, nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

-(void)showPaymentProductSelection:(GCPaymentItems *)paymentItems
{
    GCPaymentProductsViewController *paymentProductSelection = [[GCPaymentProductsViewController alloc] init];
    paymentProductSelection.target = self;
    paymentProductSelection.paymentItems = paymentItems;
    paymentProductSelection.viewFactory = self.viewFactory;
    paymentProductSelection.amount = self.amountValue;
    paymentProductSelection.currencyCode = self.context.amountOfMoney.currencyCode;
    [self.navigationController pushViewController:paymentProductSelection animated:YES];
    [SVProgressHUD dismiss];
}

- (void)didSelectPaymentItem:(NSObject <GCBasicPaymentItem> *)paymentItem accountOnFile:(GCAccountOnFile *)accountOnFile;
{
    [SVProgressHUD show];
    
    // ***************************************************************************
    //
    // After selecting a payment product or an account on file associated to a
    // payment product in the payment product selection screen, the GCSession
    // object is used to retrieve all information for this payment product.
    //
    // Afterwards, a screen is shown that allows the user to fill in all
    // relevant information, unless the payment product has no fields.
    // This screen is also not part of the SDK and is offered for demonstration
    // purposes only.
    //
    // If the payment product has no fields, the merchant is responsible for
    // fetching the URL for a redirect to a third party and show the corresponding
    // website.
    //
    // ***************************************************************************

    if ([paymentItem isKindOfClass:[GCBasicPaymentProduct class]]) {
        [self.session paymentProductWithId:paymentItem.identifier context:self.context success:^(GCPaymentProduct *paymentProduct) {
            [SVProgressHUD dismiss];
            if (paymentProduct.fields.paymentProductFields.count > 0) {
                [self showPaymentItem:paymentProduct accountOnFile:accountOnFile];
            } else {
                GCPaymentRequest *request = [[GCPaymentRequest alloc] init];
                request.paymentProduct = paymentProduct;
                request.accountOnFile = accountOnFile;
                request.tokenize = NO;
                [self didSubmitPaymentRequest:request];
            }
        }                          failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"ConnectionErrorTitle", kGCAppLocalizable, @"Title of the connection error dialog.") message:NSLocalizedStringFromTable(@"PaymentProductErrorExplanation", kGCAppLocalizable, nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }];
    }
    else if ([paymentItem isKindOfClass:[GCBasicPaymentProductGroup class]]) {
        [self.session paymentProductGroupWithId:paymentItem.identifier context:self.context success:^(GCPaymentProductGroup *paymentProductGroup) {
            [SVProgressHUD dismiss];
            [self showPaymentItem:paymentProductGroup accountOnFile:accountOnFile];
        }                               failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"ConnectionErrorTitle", kGCAppLocalizable, @"Title of the connection error dialog.") message:NSLocalizedStringFromTable(@"PaymentProductErrorExplanation", kGCAppLocalizable, nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }];
    }
}

-(void)showPaymentItem:(NSObject <GCPaymentItem> *)paymentItem accountOnFile:(GCAccountOnFile *)accountOnFile {
    GCPaymentProductViewController *paymentProductForm = [[GCPaymentProductViewController alloc] init];
    paymentProductForm.paymentRequestTarget = self;
    paymentProductForm.paymentItem = paymentItem;
    paymentProductForm.accountOnFile = accountOnFile;
    paymentProductForm.context = self.context;
    paymentProductForm.viewFactory = self.viewFactory;
    paymentProductForm.amount = self.amountValue;
    paymentProductForm.session = self.session;
    [self.navigationController pushViewController:paymentProductForm animated:YES];
}

- (void)didSubmitPaymentRequest:(GCPaymentRequest *)paymentRequest
{
    [SVProgressHUD show];
    [self.session preparePaymentRequest:paymentRequest success:^(GCPreparedPaymentRequest *preparedPaymentRequest) {
        [SVProgressHUD dismiss];
        
        // ***************************************************************************
        //
        // The information contained in preparedPaymentRequest is stored in such a way
        // that it can be sent to the GlobalCollect platform via your server.
        //
        // ***************************************************************************

        GCEndViewController *end = [[GCEndViewController alloc] init];
        end.target = self;
        end.viewFactory = self.viewFactory;
        [self.navigationController pushViewController:end animated:YES];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"ConnectionErrorTitle", kGCAppLocalizable, @"Title of the connection error dialog.") message:NSLocalizedStringFromTable(@"SubmitErrorExplanation", kGCAppLocalizable, nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)didCancelPaymentRequest
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didSelectContinueShopping
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
