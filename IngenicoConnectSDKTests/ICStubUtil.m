//
//  ICStubUtil.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICStubUtil.h"

@implementation ICStubUtil

- (NSString *)C2SBaseURLByRegion:(ICRegion)region environment:(ICEnvironment)environment
{
    return @"c2sbaseurlbyregion";
}

- (NSString *)assetsBaseURLByRegion:(ICRegion)region environment:(ICEnvironment)environment
{
    return @"assetsbaseurlbyregion";
}

- (NSString *)base64EncodedClientMetaInfoWithAppIdentifier:(NSString *)appIdentifier ipAddress:(NSString *)ipAddress addedData:(NSDictionary *)addedData {
    return @"base64encodedclientmetainfo";
}

@end
