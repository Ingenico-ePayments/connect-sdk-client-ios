//
//  GCLabelTableViewCell.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 07/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCTableViewCell.h"
#import "GCLabel.h"

@interface GCLabelTableViewCell : GCTableViewCell

@property (strong, nonatomic) GCLabel *label;
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
