//
//  ICThirdPartyStatusResponseConverter.m
//  Pods
//
//  Created for Ingenico ePayments on 13/07/2017.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//
//

#import "ICThirdPartyStatusResponseConverter.h"
#import "ICThirdPartyStatusResponse.h"
@implementation ICThirdPartyStatusResponseConverter
- (ICThirdPartyStatusResponse *)thirdPartyResponseFromJSON:(NSDictionary *)rawThirdPartyResponse {
    ICThirdPartyStatusResponse *response = [[ICThirdPartyStatusResponse alloc]init];
    NSString *thirdPartyStatusString = rawThirdPartyResponse[@"thirdPartyStatus"];
    if ([thirdPartyStatusString isEqualToString:@"WAITING"]) {
        response.thirdPartyStatus = ICThirdPartyStatusWaiting;
    }
    else if ([thirdPartyStatusString isEqualToString:@"INITIALIZED"]) {
        response.thirdPartyStatus = ICThirdPartyStatusInitialized;
    }
    else if ([thirdPartyStatusString isEqualToString:@"AUTHRORIZED"]) {
        response.thirdPartyStatus = ICThirdPartyStatusAuthorized;
    }
    else {
        response.thirdPartyStatus = ICThirdPartyStatusCompleted;
    }
    return response;
}
@end
