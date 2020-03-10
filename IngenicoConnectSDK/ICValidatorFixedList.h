//
//  ICValidatorFixedList.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICValidator.h"

@interface ICValidatorFixedList : ICValidator

@property (strong, nonatomic, readonly) NSArray *allowedValues;

- (instancetype)initWithAllowedValues:(NSArray *)allowedValues;

@end
