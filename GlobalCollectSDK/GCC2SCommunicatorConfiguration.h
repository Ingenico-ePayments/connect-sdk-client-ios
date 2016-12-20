//
//  GCC2SCommunicatorConfiguration.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 03/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCRegion.h"
#import "GCUtil.h"
#import "GCEnvironment.h"

@interface GCC2SCommunicatorConfiguration : NSObject

@property (strong, nonatomic) NSString *clientSessionId;
@property (strong, nonatomic) NSString *customerId;
@property (nonatomic) GCRegion region;
@property (nonatomic) GCEnvironment environment;

@property (nonatomic, strong) NSString *appIdentifier;
@property (nonatomic, strong) NSString *ipAddress;

- (instancetype)initWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId region:(GCRegion)region environment:(GCEnvironment)environment util:(GCUtil *)util __deprecated_msg("use method initWithClientSessionId:customerId:region:environment:appIdentifier:ipAddress:util: instead");
- (instancetype)initWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId region:(GCRegion)region environment:(GCEnvironment)environment appIdentifier:(NSString *)appIdentifier ipAddress:(NSString *)ipAddress util:(GCUtil *)util;
- (instancetype)initWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId region:(GCRegion)region environment:(GCEnvironment)environment appIdentifier:(NSString *)appIdentifier util:(GCUtil *)util;
- (NSString *)baseURL;
- (NSString *)assetsBaseURL;
- (NSString *)base64EncodedClientMetaInfo;

@end