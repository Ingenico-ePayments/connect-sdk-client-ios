//
//  GCAFNetworkingWrapper.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 28/04/15.
//  Copyright (c) 2015 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCAFNetworkingWrapper : NSObject

- (void)getResponseForURL:(NSString *)URL headers:(NSDictionary *)headers additionalAcceptableStatusCodes:(NSIndexSet *)additionalAcceptableStatusCodes succes:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
- (void)postResponseForURL:(NSString *)URL headers:(NSDictionary *)headers withParameters:(NSDictionary *)parameters additionalAcceptableStatusCodes:(NSIndexSet *)additionalAcceptableStatusCodes succes:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@end
