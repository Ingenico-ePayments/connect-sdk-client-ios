//
//  GCIINDetailsResponse.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 02/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCIINDetailsResponse.h"

@implementation GCIINDetailsResponse

- (instancetype)initWithStatus:(GCIINStatus)status {
    self = [super init];
    if (self) {
        _status = status;
    }

    return self;
}

- (instancetype)initWithPaymentProductId:(NSString *)paymentProductId status:(GCIINStatus)status coBrands:(NSArray *)coBrands countryCode:(NSString *)countryCode allowedInContext:(BOOL)allowedInContext {
    self = [super init];
    if (self) {
        _paymentProductId = paymentProductId;
        _status = status;
        _coBrands = coBrands;
        _countryCode = countryCode;
        _allowedInContext = allowedInContext;
    }

    return self;
}


@end
