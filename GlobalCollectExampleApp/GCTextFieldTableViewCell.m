//
//  GCTextFieldTableViewCell.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 10/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCTextFieldTableViewCell.h"

@implementation GCTextFieldTableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.textField != nil) {
        float width = self.contentView.frame.size.width;
        self.textField.frame = CGRectMake(10, 4, width - 20, 36);
    }
}

- (void)setTextField:(GCTextField *)textField
{
    [self.textField removeFromSuperview];
    _textField = textField;
    [self.contentView addSubview:textField];
}

- (void)dealloc
{
    [self.textField endEditing:YES];
}

@end
