//
//  GCSwitchTableViewCell.h
//  GlobalCollectSalesDemo
//
//  Created for Global Collect on 15/05/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCTableViewCell.h"

@interface GCSwitchTableViewCell : GCTableViewCell

@property (strong, nonatomic) UISwitch *switchControl;
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
