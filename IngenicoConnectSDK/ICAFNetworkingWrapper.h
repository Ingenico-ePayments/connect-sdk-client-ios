//
//  ICAFNetworkingWrapper.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICAFNetworkingWrapper : NSObject

- (void)getResponseForURL:(NSString *)URL headers:(NSDictionary *)headers additionalAcceptableStatusCodes:(NSIndexSet *)additionalAcceptableStatusCodes success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure DEPRECATED_ATTRIBUTE __deprecated_msg("use ICNetworkingWrapper#getResponseForUrl:headers:additionalAcceptableStatusCodes:success:failure instead");
- (void)postResponseForURL:(NSString *)URL headers:(NSDictionary *)headers withParameters:(NSDictionary *)parameters additionalAcceptableStatusCodes:(NSIndexSet *)additionalAcceptableStatusCodes success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure DEPRECATED_ATTRIBUTE __deprecated_msg("use ICNetworkingWrapper#postResponseForUrl:headers:additionalAcceptableStatusCodes:success:failure instead");;

@end
