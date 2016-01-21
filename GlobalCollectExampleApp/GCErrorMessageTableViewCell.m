//
//  GCErrorMessageTableViewCell.m
//  GlobalCollectSalesDemo
//
//  Created for Global Collect on 23/05/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCErrorMessageTableViewCell.h"

@implementation GCErrorMessageTableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:12.0f];
        self.textLabel.numberOfLines = 0;
        self.textLabel.textColor = [UIColor redColor];
    }
    return self;
}

@end
