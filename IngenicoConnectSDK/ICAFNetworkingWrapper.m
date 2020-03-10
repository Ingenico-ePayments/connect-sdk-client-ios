//
//  ICAFNetworkingWrapper.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import "ICAFNetworkingWrapper.h"
#import "ICMacros.h"
#import <AFNetworking/AFNetworking.h>

@interface ICAFNetworkingWrapper ()

@property (strong, nonatomic) NSString *clientSessionId;
@property (strong, nonatomic) NSString *base64EncodedClientMetaInfo;

@end

@implementation ICAFNetworkingWrapper

- (void)getResponseForURL:(NSString *)URL headers:(NSDictionary *)headers additionalAcceptableStatusCodes:(NSIndexSet *)additionalAcceptableStatusCodes success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self setHeaders:headers forManager:manager];
    
    if (additionalAcceptableStatusCodes != nil) {
        NSMutableIndexSet *acceptableStatusCodes = [[NSMutableIndexSet alloc] initWithIndexSet:manager.responseSerializer.acceptableStatusCodes];
        [acceptableStatusCodes addIndexes:additionalAcceptableStatusCodes];
        manager.responseSerializer.acceptableStatusCodes = acceptableStatusCodes;
    }

    [manager GET:URL parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionTask *task, NSError *error) {
        DLog(@"Error while retrieving response for URL %@: %@", URL, [error localizedDescription]);
    }];
}

- (void)postResponseForURL:(NSString *)URL headers:(NSDictionary *)headers withParameters:(NSDictionary *)parameters additionalAcceptableStatusCodes:(NSIndexSet *)additionalAcceptableStatusCodes success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self setHeaders:headers forManager:manager];
    
    if (additionalAcceptableStatusCodes != nil) {
        NSMutableIndexSet *acceptableStatusCodes = [[NSMutableIndexSet alloc] initWithIndexSet:manager.responseSerializer.acceptableStatusCodes];
        [acceptableStatusCodes addIndexes:additionalAcceptableStatusCodes];
        manager.responseSerializer.acceptableStatusCodes = acceptableStatusCodes;
    }
    
    [manager POST:URL parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionTask *task, NSError *error) {
        DLog(@"Error while retrieving response for URL %@: %@", URL, [error localizedDescription]);
        failure(error);
    }];
}

- (void)setHeaders:(NSDictionary *)headers forManager:(AFHTTPSessionManager *)manager {
    for (NSString *field in headers) {
        [manager.requestSerializer setValue:[headers objectForKey:field] forHTTPHeaderField:field];
    }
}

@end
