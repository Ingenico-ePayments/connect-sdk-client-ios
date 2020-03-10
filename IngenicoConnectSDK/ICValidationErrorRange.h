//
//  ICValidationErrorRange.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICValidationError.h"

@interface ICValidationErrorRange : ICValidationError

@property (nonatomic) NSInteger minValue;
@property (nonatomic) NSInteger maxValue;

@end
