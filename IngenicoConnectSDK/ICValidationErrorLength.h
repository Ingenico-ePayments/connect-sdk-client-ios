//
//  ICValidationErrorLength.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICValidationError.h"

@interface ICValidationErrorLength : ICValidationError

@property (nonatomic) NSInteger minLength;
@property (nonatomic) NSInteger maxLength;

@end
