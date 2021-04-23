//
//  ICC2SCommunicatorConfiguration.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import  "ICRegion.h"
#import  "ICUtil.h"
#import  "ICEnvironment.h"

@interface ICC2SCommunicatorConfiguration : NSObject {
    NSString *_baseURL;
}

@property (strong, nonatomic) NSString *clientSessionId;
@property (strong, nonatomic) NSString *customerId;

@property (nonatomic, strong) NSString *appIdentifier;
@property (nonatomic, strong) NSString *ipAddress;

@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSString *assetsBaseURL;

@property (nonatomic) ICRegion region DEPRECATED_ATTRIBUTE __deprecated_msg("Use the clientApiUrl and assetUrl returned in the server to server Create Client Session API to determine the connection endpoints.");
@property (nonatomic) ICEnvironment environment DEPRECATED_ATTRIBUTE __deprecated_msg("Use the clientApiUrl and assetUrl returned in the server to server Create Client Session API to determine the connection endpoints.");

- (instancetype)initWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId region:(ICRegion)region environment:(ICEnvironment)environment util:(ICUtil *)util DEPRECATED_ATTRIBUTE __deprecated_msg("Use method initWithClientSessionId:customerId:baseURL:assetBaseURL:appIdentifier:util: instead");
- (instancetype)initWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId region:(ICRegion)region environment:(ICEnvironment)environment appIdentifier:(NSString *)appIdentifier ipAddress:(NSString *)ipAddress util:(ICUtil *)util DEPRECATED_ATTRIBUTE __deprecated_msg("Use method initWithClientSessionId:customerId:baseURL:assetBaseURL:appIdentifier:ipAddress:util: instead");
- (instancetype)initWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId region:(ICRegion)region environment:(ICEnvironment)environment appIdentifier:(NSString *)appIdentifier util:(ICUtil *)util DEPRECATED_ATTRIBUTE __deprecated_msg("Use method initWithClientSessionId:customerId:baseURL:assetBaseURL:appIdentifier:util: instead");
- (instancetype)initWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId baseURL:(NSString *)baseURL assetBaseURL:(NSString *)assetBaseURL appIdentifier:(NSString *)appIdentifier util:(ICUtil *)util;
- (instancetype)initWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId baseURL:(NSString *)baseURL assetBaseURL:(NSString *)assetBaseURL appIdentifier:(NSString *)appIdentifier ipAddress:(NSString *)ipAddress util:(ICUtil *)util;
- (NSString *)base64EncodedClientMetaInfo;

@end
