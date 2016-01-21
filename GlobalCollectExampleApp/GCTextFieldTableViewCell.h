//
//  GCTextFieldTableViewCell.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 10/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCTableViewCell.h"
#import "GCTextField.h"

@interface GCTextFieldTableViewCell : GCTableViewCell

@property (strong, nonatomic) GCTextField *textField;
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
