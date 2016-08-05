//
//  GCIINDetail.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 02/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import "GCIINDetail.h"

@implementation GCIINDetail {

}
- (instancetype)initWithPaymentProductId:(NSString *)paymentProductId allowedInContext:(BOOL)allowedInContext {
    self = [super init];
    if (self) {
        _paymentProductId = paymentProductId;
        _allowedInContext = allowedInContext;
    }

    return self;
}

@end
