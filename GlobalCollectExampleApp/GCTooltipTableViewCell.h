//
//  GCTooltipTableViewCell.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 10/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCTableViewCell.h"

@interface GCTooltipTableViewCell : GCTableViewCell

@property (strong, nonatomic) UILabel *tooltipLabel;
@property (strong, nonatomic) UIImage *tooltipImage;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
