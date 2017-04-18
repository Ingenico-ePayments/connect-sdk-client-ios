//
//  ICValidators.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICValidators : NSObject

@property (strong, nonatomic) NSMutableArray *validators;
@property (nonatomic) BOOL containsSomeTimesRequiredValidator;

@end
