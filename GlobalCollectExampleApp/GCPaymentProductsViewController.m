//
//  GCPaymentProductsViewController.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 06/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCAppConstants.h"
#import "GCSDKConstants.h"
#import "GCPaymentProductsViewController.h"
#import "GCPaymentProductTableViewCell.h"
#import "GCPaymentProductsTableSection.h"
#import "GCPaymentProductsTableRow.h"
#import "GCTableSectionConverter.h"
#import "GCSummaryTableHeaderView.h"
#import "GCPaymentItems.h"
#import "GCMerchantLogoImageView.h"

@interface GCPaymentProductsViewController ()

@property (strong, nonatomic) NSMutableArray *sections;
@property (strong, nonatomic) GCSummaryTableHeaderView *header;
@property (strong, nonatomic) NSBundle *sdkBundle;

@end

@implementation GCPaymentProductsViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    NSString *sdkBundlePath = [[NSBundle mainBundle] pathForResource:@"GlobalCollectSDK" ofType:@"bundle"];
    self.sdkBundle = [NSBundle bundleWithPath:sdkBundlePath];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.titleView = [[GCMerchantLogoImageView alloc] init];
    
    [self initializeHeader];
    
    self.sections = [[NSMutableArray alloc] init];
    //TODO: Accounts on file
    if ([self.paymentItems hasAccountsOnFile] == YES) {
        GCPaymentProductsTableSection *accountsSection =
        [GCTableSectionConverter paymentProductsTableSectionFromAccountsOnFile:[self.paymentItems accountsOnFile] paymentItems:self.paymentItems];
        accountsSection.title = NSLocalizedStringFromTableInBundle(@"gc.app.paymentProductSelection.accountsOnFileTitle", kGCSDKLocalizable, self.sdkBundle, @"Title of the section that displays stored payment products.");
        [self.sections addObject:accountsSection];
    }
    GCPaymentProductsTableSection *productsSection = [GCTableSectionConverter paymentProductsTableSectionFromPaymentItems:self.paymentItems];
    productsSection.title = NSLocalizedStringFromTable(@"gc.app.paymentProductSelection.pageTitle", kGCSDKLocalizable, @"Title of the section that shows all available payment products.");
    [self.sections addObject:productsSection];
}

- (void)initializeHeader
{
    self.header = (GCSummaryTableHeaderView *)[self.viewFactory tableHeaderViewWithType:GCSummaryTableHeaderViewType frame:CGRectMake(0, 0, self.tableView.frame.size.width, 70)];
    self.header.summary = [NSString stringWithFormat:@"%@:", NSLocalizedStringFromTableInBundle(@"gc.app.general.shoppingCart.total", kGCSDKLocalizable, self.sdkBundle, @"Description of the amount header.")];
    NSNumber *amountAsNumber = [[NSNumber alloc] initWithFloat:self.amount / 100.0];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencyCode:self.currencyCode];
    NSString *amountAsString = [numberFormatter stringFromNumber:amountAsNumber];
    self.header.amount = amountAsString;
    self.header.securePayment = NSLocalizedStringFromTableInBundle(@"gc.app.general.securePaymentText", kGCSDKLocalizable, self.sdkBundle, @"Text indicating that a secure payment method is used.");
    self.tableView.tableHeaderView = self.header;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    GCPaymentProductsTableSection *tableSection = self.sections[section];
    return tableSection.rows.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    GCPaymentProductsTableSection *tableSection = self.sections[section];
    return tableSection.title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"cell";
    GCPaymentProductTableViewCell *cell = (GCPaymentProductTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = (GCPaymentProductTableViewCell *)[self.viewFactory tableViewCellWithType:GCPaymentProductTableViewCellType reuseIdentifier:reuseIdentifier];
    }
    
    GCPaymentProductsTableSection *section = self.sections[indexPath.section];
    GCPaymentProductsTableRow *row = section.rows[indexPath.row];
    cell.name = row.name;
    cell.logo = row.logo;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCPaymentProductsTableSection *section = self.sections[indexPath.section];
    GCPaymentProductsTableRow *row = section.rows[indexPath.row];
    NSObject<GCBasicPaymentItem> *paymentItem = [self.paymentItems paymentItemWithIdentifier:row.paymentProductIdentifier];
    if (section.type == GCAccountOnFileType) {
        GCBasicPaymentProduct *product = (GCBasicPaymentProduct *) paymentItem;
        GCAccountOnFile *accountOnFile = [product accountOnFileWithIdentifier:row.accountOnFileIdentifier];
        [self.target didSelectPaymentItem:product accountOnFile:accountOnFile];
    }
    else {
        [self.target didSelectPaymentItem:paymentItem accountOnFile:nil];
    }
}

@end
