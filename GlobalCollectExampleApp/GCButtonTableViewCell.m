//
//  GCButtonTableViewCell.m
//  GlobalCollectSalesDemo
//
//  Created for Global Collect on 15/05/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCButtonTableViewCell.h"

@interface GCButtonTableViewCell ()

@end

@implementation GCButtonTableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        UIScrollView *scrollView = (UIScrollView *)self.contentView.superview;
        if ([scrollView respondsToSelector:@selector(setDelaysContentTouches:)] == YES) {
            ((UIScrollView *)self.contentView.superview).delaysContentTouches = NO;
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.button != nil) {
        float height = self.contentView.frame.size.height;
        float width = self.contentView.frame.size.width;
    
        self.button.frame = CGRectMake(10, 4, width - 20, height - 8);
    }
}

- (void)setButton:(UIButton *)button
{
    [self.button removeFromSuperview];
    _button = button;
    [self addSubview:button];
}

@end
