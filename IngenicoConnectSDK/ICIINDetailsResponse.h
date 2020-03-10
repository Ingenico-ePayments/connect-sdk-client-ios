//
//  ICIINDetailsResponse.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import  "ICIINStatus.h"

@interface ICIINDetailsResponse : NSObject

@property (strong, nonatomic, readonly) NSString* paymentProductId;
@property (nonatomic, readonly) ICIINStatus status;

@property (strong, nonatomic, readonly) NSArray *coBrands;
@property (strong, nonatomic, readonly) NSString *countryCode;
@property (assign, nonatomic, readonly, getter=isAllowedInContext) BOOL allowedInContext;

- (instancetype)initWithStatus:(ICIINStatus)status;
- (instancetype)initWithPaymentProductId:(NSString *)paymentProductId status:(ICIINStatus)status coBrands:(NSArray *)coBrands countryCode:(NSString *)countryCode allowedInContext:(BOOL)allowedInContext;

@end
