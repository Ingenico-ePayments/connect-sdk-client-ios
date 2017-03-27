//
//  ICC2SCommunicatorConfiguration.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <IngenicoConnectSDK/ICC2SCommunicatorConfiguration.h>

@interface ICC2SCommunicatorConfiguration ()

@property (strong, nonatomic) ICUtil *util;

@end

@implementation ICC2SCommunicatorConfiguration

- (instancetype)initWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId region:(ICRegion)region environment:(ICEnvironment)environment util:(ICUtil *)util
{
    return [self initWithClientSessionId:clientSessionId customerId:customerId region:region environment:environment appIdentifier:nil ipAddress:nil util:util];
}

- (instancetype)initWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId region:(ICRegion)region environment:(ICEnvironment)environment appIdentifier:(NSString *)appIdentifier util:(ICUtil *)util {
    return [self initWithClientSessionId:clientSessionId customerId:customerId region:region environment:environment appIdentifier:appIdentifier ipAddress:nil util:util];
}

- (instancetype)initWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId region:(ICRegion)region environment:(ICEnvironment)environment appIdentifier:(NSString *)appIdentifier ipAddress:(NSString *)ipAddress util:(ICUtil *)util {
    self = [super init];
    if (self != nil) {
        self.clientSessionId = clientSessionId;
        self.customerId = customerId;
        self.region = region;
        self.environment = environment;
        self.util = util;
        self.appIdentifier = appIdentifier;
        self.ipAddress = ipAddress;
    }
    return self;

}


- (NSString *)baseURL
{
    return [self.util C2SBaseURLByRegion:self.region environment:self.environment];
}

- (NSString *)assetsBaseURL
{
    return [self.util assetsBaseURLByRegion:self.region environment:self.environment];
}

- (NSString *)base64EncodedClientMetaInfo
{
    return [self.util base64EncodedClientMetaInfoWithAppIdentifier:self.appIdentifier ipAddress:self.ipAddress];
}


@end
