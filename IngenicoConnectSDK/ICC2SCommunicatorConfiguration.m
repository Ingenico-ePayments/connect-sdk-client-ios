//
//  ICC2SCommunicatorConfiguration.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <IngenicoConnectSDK/ICC2SCommunicatorConfiguration.h>
#import "ICSDKConstants.h"
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
- (instancetype)initWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId baseURL:(NSString *)baseURL assetBaseURL:(NSString *)assetBaseURL appIdentifier:(NSString *)appIdentifier util:(ICUtil *)util {
    self = [super init];
    if (self != nil) {
        self.clientSessionId = clientSessionId;
        self.customerId = customerId;
        self.baseURL = baseURL;
        self.assetsBaseURL = assetBaseURL;
        self.util = util;
        self.appIdentifier = appIdentifier;
    }
    return self;
}
- (instancetype)initWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId baseURL:(NSString *)baseURL assetBaseURL:(NSString *)assetBaseURL appIdentifier:(NSString *)appIdentifier ipAddress:(NSString *)ipAddress util:(ICUtil *)util {
    self = [super init];
    if (self != nil) {
        self.clientSessionId = clientSessionId;
        self.customerId = customerId;
        self.baseURL = baseURL;
        self.assetsBaseURL = assetBaseURL;
        self.util = util;
        self.appIdentifier = appIdentifier;
        self.ipAddress = ipAddress;
    }
    return self;
}

- (NSString *)fixURL:(NSString *)url
{
    NSMutableArray<NSString *> *components;
    if (@available(iOS 7.0, *)) {
        NSURLComponents *finalComponents = [NSURLComponents componentsWithString:url];
        components = [[finalComponents.path componentsSeparatedByString:@"/"] filteredArrayUsingPredicate:
                      [NSPredicate predicateWithFormat:@"length > 0"]].mutableCopy;
    }
    else {
        components = [[[NSURL URLWithString:url].path componentsSeparatedByString:@"/"] filteredArrayUsingPredicate:
                      [NSPredicate predicateWithFormat:@"length > 0"]].mutableCopy;
    }
    
    
    NSArray<NSString *> *versionComponents = [kICAPIVersion componentsSeparatedByString:@"/"];
    NSString *exceptionReason = [NSString stringWithFormat: @"This version of the connectSDK is only compatible with %@ , you supplied: '%@'",
                                 [versionComponents componentsJoinedByString: @"/"],
                                 [components componentsJoinedByString: @"/"]];
    NSException *invalidURLException = [NSException exceptionWithName:@"ICInvalidURLException"
                                                               reason:exceptionReason
                                                             userInfo:nil];
    NSURL *nsurl = [NSURL URLWithString:url];
    switch (components.count) {
        case 0: {
            components = versionComponents.mutableCopy;
            break;
        }
        case 1: {
            if (![components[0] isEqualToString:versionComponents[0]]) {
                @throw invalidURLException;
            }
            [components addObject:versionComponents[1]];
            break;
        }
        case 2: {
            if (![components[0] isEqualToString:versionComponents[0]]) {
                @throw invalidURLException;
            }
            if (![components[1] isEqualToString:versionComponents[1]]) {
                @throw invalidURLException;
            }
            break;
        }
        default: {
            @throw invalidURLException;
            break;
        }
    }
    if (@available(iOS 7.0, *)) {
        NSURLComponents *finalComponents = [NSURLComponents componentsWithString:url];
        finalComponents.path = [@"/" stringByAppendingString:[components componentsJoinedByString:@"/"]];
        return finalComponents.URL.absoluteString;
    }
    while ([nsurl.path stringByReplacingOccurrencesOfString:@"/" withString:@""].length) {
        nsurl = [nsurl URLByDeletingLastPathComponent];
    }
    for (NSString *component in components) {
        nsurl = [nsurl URLByAppendingPathComponent:component];
    }
    return nsurl.absoluteString;
}
- (void)setBaseURL:(NSString *)baseURL {
    self->_baseURL = [self fixURL:baseURL];
}
- (NSString *)baseURL
{
    if (self->_baseURL != nil) {
        return self->_baseURL;
    }
    return [self.util C2SBaseURLByRegion:self.region environment:self.environment];
}
- (NSString *)assetsBaseURL
{
    if (self->_assetsBaseURL != nil) {
        return self->_assetsBaseURL;
    }
    return [self.util assetsBaseURLByRegion:self.region environment:self.environment];
}

- (NSString *)base64EncodedClientMetaInfo
{
    return [self.util base64EncodedClientMetaInfoWithAppIdentifier:self.appIdentifier ipAddress:self.ipAddress];
}


@end
