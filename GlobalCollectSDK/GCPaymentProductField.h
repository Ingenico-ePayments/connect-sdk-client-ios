//
//  GCPaymentProductField.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCPaymentProductFieldDisplayHints.h"
#import "GCDataRestrictions.h"
#import "GCType.h"

@interface GCPaymentProductField : NSObject

@property (strong, nonatomic) GCDataRestrictions *dataRestrictions;
@property (strong, nonatomic) GCPaymentProductFieldDisplayHints *displayHints;
@property (strong, nonatomic) NSString *identifier;
@property (nonatomic) GCType type;

@property (strong, nonatomic) NSMutableArray *errors;

- (void)validateValue:(NSString *)value;

@end
