//
//  ICIINDetailsResponse.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICIINDetailsResponse.h"

@implementation ICIINDetailsResponse

- (instancetype)initWithStatus:(ICIINStatus)status {
    self = [super init];
    if (self) {
        _status = status;
    }

    return self;
}

- (instancetype)initWithPaymentProductId:(NSString *)paymentProductId status:(ICIINStatus)status coBrands:(NSArray *)coBrands countryCode:(NSString *)countryCode allowedInContext:(BOOL)allowedInContext {
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
