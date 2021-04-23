//
//  ICAFNetworkingWrapper.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICAFNetworkingWrapper.h"
#import "ICNetworkingWrapper.h"

@interface ICAFNetworkingWrapper ()

    @property (strong, nonatomic) ICNetworkingWrapper *_icNetworkingWrapper;

@end

@implementation ICAFNetworkingWrapper

- (instancetype)init {

    self._icNetworkingWrapper = [[ICNetworkingWrapper alloc] init];

    return self;
}


- (void)getResponseForURL:(NSString *)URL headers:(NSDictionary *)headers additionalAcceptableStatusCodes:(NSIndexSet *)additionalAcceptableStatusCodes success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NSLog(@"ICAFNetworkingWrapper is deprecated! Use ICNetworkingWrapper instead.");
    [self._icNetworkingWrapper getResponseForURL:URL headers:headers additionalAcceptableStatusCodes:additionalAcceptableStatusCodes success:success failure:failure];
}


- (void)postResponseForURL:(NSString *)URL headers:(NSDictionary *)headers withParameters:(NSDictionary *)parameters additionalAcceptableStatusCodes:(NSIndexSet *)additionalAcceptableStatusCodes success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NSLog(@"ICAFNetworkingWrapper is deprecated! Use ICNetworkingWrapper instead.");
    [self._icNetworkingWrapper postResponseForURL:URL headers:headers withParameters:parameters additionalAcceptableStatusCodes:additionalAcceptableStatusCodes success:success failure:failure];
}

@end
