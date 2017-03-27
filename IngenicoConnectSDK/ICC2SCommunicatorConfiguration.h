//
//  ICC2SCommunicatorConfiguration.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <IngenicoConnectSDK/ICRegion.h>
#import <IngenicoConnectSDK/ICUtil.h>
#import <IngenicoConnectSDK/ICEnvironment.h>

@interface ICC2SCommunicatorConfiguration : NSObject

@property (strong, nonatomic) NSString *clientSessionId;
@property (strong, nonatomic) NSString *customerId;
@property (nonatomic) ICRegion region;
@property (nonatomic) ICEnvironment environment;

@property (nonatomic, strong) NSString *appIdentifier;
@property (nonatomic, strong) NSString *ipAddress;

- (instancetype)initWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId region:(ICRegion)region environment:(ICEnvironment)environment util:(ICUtil *)util __deprecated_msg("use method initWithClientSessionId:customerId:region:environment:appIdentifier:ipAddress:util: instead");
- (instancetype)initWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId region:(ICRegion)region environment:(ICEnvironment)environment appIdentifier:(NSString *)appIdentifier ipAddress:(NSString *)ipAddress util:(ICUtil *)util;
- (instancetype)initWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId region:(ICRegion)region environment:(ICEnvironment)environment appIdentifier:(NSString *)appIdentifier util:(ICUtil *)util;
- (NSString *)baseURL;
- (NSString *)assetsBaseURL;
- (NSString *)base64EncodedClientMetaInfo;

@end
