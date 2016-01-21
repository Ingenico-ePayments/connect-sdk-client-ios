//
//  GCPickerViewTableViewCell.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 10/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCPickerViewTableViewCell.h"

@implementation GCPickerViewTableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.pickerView != nil) {
        float width = self.contentView.frame.size.width;
        self.pickerView.frame = CGRectMake(10, 0, width - 20, 162);
    }
}

- (void)setPickerView:(GCPickerView *)pickerView
{
    [self.pickerView removeFromSuperview];
    _pickerView = pickerView;
    [self.contentView addSubview:pickerView];
}

@end
