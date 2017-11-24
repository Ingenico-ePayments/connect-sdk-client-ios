//
//  ICThirdPartyStatusResponseConverter.h
//  Pods
//
//  Created for Ingenico ePayments on 13/07/2017.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//
//

#import <Foundation/Foundation.h>
@class ICThirdPartyStatusResponse;
@interface ICThirdPartyStatusResponseConverter : NSObject
- (ICThirdPartyStatusResponse *)thirdPartyResponseFromJSON:(NSDictionary *)rawThirdPartyResponse;
@end
