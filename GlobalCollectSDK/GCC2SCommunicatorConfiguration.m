//
//  GCC2SCommunicatorConfiguration.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 03/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCC2SCommunicatorConfiguration.h"

@interface GCC2SCommunicatorConfiguration ()

@property (strong, nonatomic) GCUtil *util;

@end

@implementation GCC2SCommunicatorConfiguration

- (instancetype)initWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId region:(GCRegion)region environment:(GCEnvironment)environment util:(GCUtil *)util
{
    self = [super init];
    if (self != nil) {
        self.clientSessionId = clientSessionId;
        self.customerId = customerId;
        self.region = region;
        self.environment = environment;
        self.util = util;
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
    return [self.util base64EncodedClientMetaInfo];
}


@end
