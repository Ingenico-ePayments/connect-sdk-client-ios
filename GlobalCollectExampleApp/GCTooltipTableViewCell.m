//
//  GCTooltipTableViewCell.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 10/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCTooltipTableViewCell.h"

@interface GCTooltipTableViewCell ()

@property (strong, nonatomic) UIImageView *tooltipImageContainer;

@end

@implementation GCTooltipTableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self != nil) {
        self.tooltipImageContainer = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.tooltipImageContainer.contentMode = UIViewContentModeScaleAspectFit;
        self.tooltipLabel = [[UILabel alloc] init];
        self.tooltipLabel.font = [UIFont systemFontOfSize:10.0f];
        self.tooltipLabel.numberOfLines = 0;
        [self.contentView addSubview:self.tooltipImageContainer];
        [self.contentView addSubview:self.tooltipLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    float width = self.contentView.frame.size.width;
    
    self.tooltipLabel.frame = CGRectMake(15, 10, width - 30, 40);
    self.tooltipImageContainer.frame = CGRectMake(10, 50, 200, 100);
}

- (void)setTooltipImage:(UIImage *)tooltipImage
{
    _tooltipImage = tooltipImage;
    [self.tooltipImageContainer setImage:tooltipImage];
}

@end
