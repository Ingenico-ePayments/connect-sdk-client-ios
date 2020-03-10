//
//  ICValidatorRange.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICValidator.h"

@interface ICValidatorRange : ICValidator

@property (nonatomic) NSInteger minValue;
@property (nonatomic) NSInteger maxValue;
@end
