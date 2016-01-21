//
//  GCDataRestrictions.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCValidators.h"

@interface GCDataRestrictions : NSObject

@property (nonatomic) BOOL isRequired;
@property (strong, nonatomic) GCValidators *validators;

@end
