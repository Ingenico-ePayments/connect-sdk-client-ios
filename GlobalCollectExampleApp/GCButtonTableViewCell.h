//
//  GCButtonTableViewCell.h
//  GlobalCollectSalesDemo
//
//  Created for Global Collect on 15/05/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCTableViewCell.h"

@interface GCButtonTableViewCell : GCTableViewCell

@property (strong, nonatomic) UIButton *button;
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
