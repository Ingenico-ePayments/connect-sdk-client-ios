//
//  ICDataRestrictions.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import  "ICValidators.h"

@interface ICDataRestrictions : NSObject

@property (nonatomic) BOOL isRequired;
@property (strong, nonatomic) ICValidators *validators;

@end
