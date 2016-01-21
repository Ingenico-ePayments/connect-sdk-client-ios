//
//  GCPickerViewTableViewCell.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 10/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCTableViewCell.h"
#import "GCPickerView.h"

@interface GCPickerViewTableViewCell : GCTableViewCell

@property (strong, nonatomic) GCPickerView *pickerView;
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
