//
//  GCPaymentProductTableViewCell.m
//  GlobalCollectSalesDemo
//
//  Created for Global Collect on 13/05/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCPaymentProductTableViewCell.h"

@interface GCPaymentProductTableViewCell ()

@property (strong, nonatomic) UIImageView *logoContainer;

@end

@implementation GCPaymentProductTableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.logoContainer = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.logoContainer.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.logoContainer];
        self.textLabel.adjustsFontSizeToFitWidth = NO;
        self.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    float width = self.contentView.frame.size.width;
    float height = self.contentView.frame.size.height;
    
    int padding = 15;
    int logoWidth = 35;

    int textLabelX;
    if (self.logo != nil) {
        textLabelX = padding + logoWidth + padding;
        self.logoContainer.frame = CGRectMake(padding, 5, logoWidth, height - 10);
    } else {
        textLabelX = padding;
    }
    self.textLabel.frame = CGRectMake(textLabelX, 0, width - textLabelX - padding, height);
}

- (void)setLogo:(UIImage *)logo
{
    _logo = logo;
    [self.logoContainer setImage:logo];
}

- (void)setName:(NSString *)name
{
    _name = name;
    self.textLabel.text = self.name;
}

@end
