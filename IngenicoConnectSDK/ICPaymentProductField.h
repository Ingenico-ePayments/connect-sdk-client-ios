//
//  ICPaymentProductField.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import  "ICPaymentProductFieldDisplayHints.h"
#import  "ICDataRestrictions.h"
#import  "ICType.h"

@class ICPaymentRequest;

@interface ICPaymentProductField : NSObject

@property (strong, nonatomic) ICDataRestrictions *dataRestrictions;
@property (strong, nonatomic) ICPaymentProductFieldDisplayHints *displayHints;
@property (strong, nonatomic) NSString *identifier;
@property (assign, nonatomic) BOOL usedForLookup;
@property (nonatomic) ICType type;
@property (strong, nonatomic) NSMutableArray *errors;

- (void)validateValue:(NSString *)value DEPRECATED_ATTRIBUTE __deprecated_msg("Use validateValue:value:forPaymentRequest instead");
- (void)validateValue:(NSString *)value forPaymentRequest:(ICPaymentRequest *)request;

@end
