//
//  GCFormRowTextField.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 10/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCFormRowWithInfoButton.h"
#import "GCTextField.h"
#import "GCPaymentProductField.h"

@interface GCFormRowTextField : GCFormRowWithInfoButton

@property (strong, nonatomic) GCTextField *textField;
@property (strong, nonatomic) GCPaymentProductField *paymentProductField;
@property (strong, nonatomic) UIImageView *logo;

@end
