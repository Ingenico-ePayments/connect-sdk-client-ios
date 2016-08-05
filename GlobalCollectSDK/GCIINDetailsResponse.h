//
//  GCIINDetailsResponse.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 02/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCIINStatus.h"

@interface GCIINDetailsResponse : NSObject

@property (strong, nonatomic, readonly) NSString* paymentProductId;
@property (nonatomic, readonly) GCIINStatus status;

@property (strong, nonatomic, readonly) NSArray *coBrands;
@property (strong, nonatomic, readonly) NSString *countryCode;
@property (assign, nonatomic, readonly, getter=isAllowedInContext) BOOL allowedInContext;

- (instancetype)initWithStatus:(GCIINStatus)status;
- (instancetype)initWithPaymentProductId:(NSString *)paymentProductId status:(GCIINStatus)status coBrands:(NSArray *)coBrands countryCode:(NSString *)countryCode allowedInContext:(BOOL)allowedInContext;

@end
