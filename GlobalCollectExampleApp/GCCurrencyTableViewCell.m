//
//  GCCurrencyTableViewCell.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 21/10/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCCurrencyTableViewCell.h"
#import "GCSDKConstants.h"

@interface GCCurrencyTableViewCell ()

@property (strong, nonatomic) UILabel *separatorlabel;
@property (strong, nonatomic) UILabel *currencyCodeLabel;

@end

@implementation GCCurrencyTableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self != nil) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];

        self.separatorlabel = [[UILabel alloc] init];
        self.separatorlabel.text = [formatter decimalSeparator];
        [self.contentView addSubview:self.separatorlabel];
        
        self.currencyCodeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.currencyCodeLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    float width = self.contentView.frame.size.width;
    int padding = 10;
    int currencyCodeWidth = 36;
    int fractionalWidth = 50;
    int separatorWidth = 8;
    
    int currencyCodeX = padding;
    int integerX = currencyCodeX + currencyCodeWidth + padding;
    int separatorX = width - padding - fractionalWidth - padding - separatorWidth;
    int fractionalX = width - padding - fractionalWidth;
    int integerWidth = separatorX - padding - integerX;
    
    self.separatorlabel.frame = CGRectMake(separatorX, 7, separatorWidth, 30);
    self.currencyCodeLabel.frame = CGRectMake(currencyCodeX, 7, currencyCodeWidth, 30);
    if (self.integerTextField != nil) {
        self.integerTextField.frame = CGRectMake(integerX, 4, integerWidth, 36);
    }
    if (self.fractionalTextField != nil) {
        self.fractionalTextField.frame = CGRectMake(fractionalX, 4, fractionalWidth, 36);
    }
}

- (void)setIntegerTextField:(GCIntegerTextField *)integerTextField
{
    [self.integerTextField removeFromSuperview];
    _integerTextField = integerTextField;
    [self.contentView addSubview:integerTextField];
}

- (void)setFractionalTextField:(GCFractionalTextField *)fractionalTextField
{
    [self.fractionalTextField removeFromSuperview];
    _fractionalTextField = fractionalTextField;
    [self.contentView addSubview:fractionalTextField];
}

- (void)setCurrencyCode:(NSString *)currencyCode
{
    _currencyCode = currencyCode;
    self.currencyCodeLabel.text = currencyCode;
}

- (void)dealloc
{
    [self.integerTextField endEditing:YES];
    [self.fractionalTextField endEditing:YES];
}

@end
