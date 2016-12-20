//
//  GCFormRowTooltip.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 11/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCFormRow.h"
#import "GCPaymentProductField.h"

@interface GCFormRowTooltip : GCFormRow

@property (strong, nonatomic) GCPaymentProductField *paymentProductField;
@property (nonatomic, strong) NSString *tooltipIdentifier;
@property (strong, nonatomic) UIImage *tooltipImage;
@property (strong, nonatomic) NSString *tooltipText;

@end
