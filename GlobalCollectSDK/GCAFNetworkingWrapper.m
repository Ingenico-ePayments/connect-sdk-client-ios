//
//  GCAFNetworkingWrapper.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 28/04/15.
//  Copyright (c) 2015 Global Collect Services B.V. All rights reserved.
//

#import "GCAFNetworkingWrapper.h"
#import "AFNetworking.h"
#import "GCMacros.h"

@interface GCAFNetworkingWrapper ()

@property (strong, nonatomic) NSString *clientSessionId;
@property (strong, nonatomic) NSString *base64EncodedClientMetaInfo;

@end

@implementation GCAFNetworkingWrapper

- (void)getResponseForURL:(NSString *)URL headers:(NSDictionary *)headers additionalAcceptableStatusCodes:(NSIndexSet *)additionalAcceptableStatusCodes succes:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self setHeaders:headers forManager:manager];
    
    if (additionalAcceptableStatusCodes != nil) {
        NSMutableIndexSet *acceptableStatusCodes = [[NSMutableIndexSet alloc] initWithIndexSet:manager.responseSerializer.acceptableStatusCodes];
        [acceptableStatusCodes addIndexes:additionalAcceptableStatusCodes];
        manager.responseSerializer.acceptableStatusCodes = acceptableStatusCodes;
    }
    
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"Error while retrieving response for URL %@: %@", URL, [error localizedDescription]);
        failure(error);
    }];
}

- (void)postResponseForURL:(NSString *)URL headers:(NSDictionary *)headers withParameters:(NSDictionary *)parameters additionalAcceptableStatusCodes:(NSIndexSet *)additionalAcceptableStatusCodes succes:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self setHeaders:headers forManager:manager];
    
    if (additionalAcceptableStatusCodes != nil) {
        NSMutableIndexSet *acceptableStatusCodes = [[NSMutableIndexSet alloc] initWithIndexSet:manager.responseSerializer.acceptableStatusCodes];
        [acceptableStatusCodes addIndexes:additionalAcceptableStatusCodes];
        manager.responseSerializer.acceptableStatusCodes = acceptableStatusCodes;
    }
    
    [manager POST:URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"Error while retrieving response for URL %@: %@", URL, [error localizedDescription]);
        failure(error);
    }];
}

- (void)setHeaders:(NSDictionary *)headers forManager:(AFHTTPRequestOperationManager *)manager {
    for (NSString *field in headers) {
        [manager.requestSerializer setValue:[headers objectForKey:field] forHTTPHeaderField:field];
    }
}

@end
