//
//  GCSummaryTableHeaderView.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 01/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCSummaryTableHeaderView.h"

@interface GCSummaryTableHeaderView ()

@property (strong, nonatomic) UILabel *summaryLabel;
@property (strong, nonatomic) UILabel *amountLabel;
@property (strong, nonatomic) UILabel *securePaymentLabel;

@end

@implementation GCSummaryTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *securePaymentContainer = [[UIView alloc] init];
        securePaymentContainer.translatesAutoresizingMaskIntoConstraints = NO;
        UIImageView *securePaymentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        securePaymentIcon.contentMode = UIViewContentModeScaleAspectFit;
        securePaymentIcon.image = [UIImage imageNamed:@"SecurePaymentIcon"];
        securePaymentIcon.translatesAutoresizingMaskIntoConstraints = NO;
        self.securePaymentLabel = [[UILabel alloc] init];
        self.securePaymentLabel.textColor = [UIColor colorWithRed:0 green:0.8 blue:0 alpha:1];
        self.securePaymentLabel.backgroundColor = [UIColor clearColor];
        self.securePaymentLabel.font = [UIFont systemFontOfSize:12];
        self.securePaymentLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [securePaymentContainer addSubview:securePaymentIcon];
        [securePaymentContainer addSubview:self.securePaymentLabel];
        
        UIView *banner = [[UIView alloc] init];
        banner.layer.cornerRadius = 5.0;
        banner.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        banner.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:banner];
        [self addSubview:securePaymentContainer];

        self.summaryLabel = [[UILabel alloc] init];
        self.summaryLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.summaryLabel.font = [UIFont boldSystemFontOfSize:16];
        self.summaryLabel.backgroundColor = [UIColor clearColor];
        self.amountLabel = [[UILabel alloc] init];
        self.amountLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.amountLabel.font = [UIFont boldSystemFontOfSize:16];
        self.amountLabel.backgroundColor = [UIColor clearColor];
        [banner addSubview:self.summaryLabel];
        [banner addSubview:self.amountLabel];
        
        NSDictionary *viewMapping = NSDictionaryOfVariableBindings(_summaryLabel, _amountLabel, securePaymentContainer, securePaymentIcon, _securePaymentLabel, banner);
        NSDictionary *metrics = @{@"bannerInnerMargin": @"8"};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(10)-[banner]-(10)-|" options:0 metrics:nil views:viewMapping]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[securePaymentContainer]-(10)-|" options:0 metrics:nil views:viewMapping]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[banner]-(1)-[securePaymentContainer]" options:0 metrics:nil views:viewMapping]];
        [banner addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(bannerInnerMargin)-[_summaryLabel]" options:0 metrics:metrics views:viewMapping]];
        [banner addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_amountLabel]-(bannerInnerMargin)-|" options:0 metrics:metrics views:viewMapping]];
        [banner addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(bannerInnerMargin)-[_summaryLabel]-(bannerInnerMargin)-|" options:0 metrics:metrics views:viewMapping]];
        [banner addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(bannerInnerMargin)-[_amountLabel]-(bannerInnerMargin)-|" options:0 metrics:metrics views:viewMapping]];
        [securePaymentContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[securePaymentIcon(==7)]-(3)-[_securePaymentLabel]|" options:0 metrics:nil views:viewMapping]];
        [securePaymentContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_securePaymentLabel(==20)]" options:0 metrics:nil views:viewMapping]];
        [securePaymentContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(5)-[securePaymentIcon(==7)]" options:0 metrics:nil views:viewMapping]];
    }
    return self;
}

- (void)setSummary:(NSString *)summary
{
    self.summaryLabel.text = summary;
}

- (void)setAmount:(NSString *)amount
{
    self.amountLabel.text = amount;
}

- (void)setSecurePayment:(NSString *)securePayment
{
    self.securePaymentLabel.text = securePayment;
}

@end
