//
//  GCIINDetailsResponse.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 02/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCIINDetailsResponse.h"

@implementation GCIINDetailsResponse

- (instancetype)initWithPaymentProductId:(NSString *)paymentProductId status:(GCIINStatus)status
{
    self = [super init];
    if (self != nil) {
        _paymentProductId = paymentProductId;
        _status = status;
    }
    return self;
}

@end
