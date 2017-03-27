//
//  ICValidatorRegularExpression.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <IngenicoConnectSDK/ICValidator.h>

@interface ICValidatorRegularExpression : ICValidator

@property (strong, nonatomic, readonly) NSRegularExpression *regularExpression;

- (instancetype)initWithRegularExpression:(NSRegularExpression *)regularExpression;

@end
