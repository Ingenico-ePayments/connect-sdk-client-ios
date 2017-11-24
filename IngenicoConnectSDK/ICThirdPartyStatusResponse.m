//
//  ICThirdPartyStatusResponse.m
//  Pods
//
//  Created for Ingenico ePayments on 13/07/2017.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//
//

#import "ICThirdPartyStatusResponse.h"

@implementation ICThirdPartyStatusResponse
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.thirdPartyStatus = ICThirdPartyStatusWaiting;
    }
    return self;
}
@end
