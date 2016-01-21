//
//  GCCurrencyTableViewCell.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 21/10/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCTableViewCell.h"
#import "GCIntegerTextField.h"
#import "GCFractionalTextField.h"

@interface GCCurrencyTableViewCell : GCTableViewCell

@property (strong, nonatomic) GCIntegerTextField *integerTextField;
@property (strong, nonatomic) GCFractionalTextField *fractionalTextField;
@property (strong, nonatomic) NSString *currencyCode;
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
