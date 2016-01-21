//
//  GCViewFactory.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCViewType.h"
#import "GCTableViewCell.h"
#import "GCButton.h"
#import "GCSwitch.h"
#import "GCTextField.h"
#import "GCPickerView.h"
#import "GCLAbel.h"

@interface GCViewFactory : NSObject

- (GCTableViewCell *)tableViewCellWithType:(GCViewType)type reuseIdentifier:(NSString *)reuseIdentifier;
- (GCButton *)buttonWithType:(GCViewType)type;
- (GCSwitch *)switchWithType:(GCViewType)type;
- (GCTextField *)textFieldWithType:(GCViewType)type;
- (GCPickerView *)pickerViewWithType:(GCViewType)type;
- (GCLabel *)labelWithType:(GCViewType)type;
- (UIView *)tableHeaderViewWithType:(GCViewType)type frame:(CGRect)frame;

@end
