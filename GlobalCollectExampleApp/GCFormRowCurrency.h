//
//  GCFormRowCurrency.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 20/10/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCFormRowWithInfoButton.h"
#import "GCIntegerTextField.h"
#import "GCFractionalTextField.h"
#import "GCPaymentProductField.h"

@interface GCFormRowCurrency : GCFormRowWithInfoButton

@property (strong, nonatomic) GCIntegerTextField *integerTextField;
@property (strong, nonatomic) GCFractionalTextField *fractionalTextField;
@property (strong, nonatomic) GCPaymentProductField *paymentProductField;

@end
