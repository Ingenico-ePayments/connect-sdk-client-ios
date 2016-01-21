//
//  GCLabelTableViewCell.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 07/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCLabelTableViewCell.h"

@interface GCLabelTableViewCell ()

@property (strong, nonatomic) UIView *labelView;

@end

@implementation GCLabelTableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.label != nil) {
        float width = self.contentView.frame.size.width;
        self.label.frame = CGRectMake(10, 4, width - 20, 36);
    }
}

- (void)setLabel:(GCLabel *)label
{
    [self.label removeFromSuperview];
    _label = label;
    [self.contentView addSubview:self.label];
}

@end
