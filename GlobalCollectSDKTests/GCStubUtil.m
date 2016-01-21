//
//  GCStubUtil.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 17/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCStubUtil.h"

@implementation GCStubUtil

- (NSString *)C2SBaseURLByRegion:(GCRegion)region environment:(GCEnvironment)environment
{
    return @"c2sbaseurlbyregion";
}

- (NSString *)assetsBaseURLByRegion:(GCRegion)region environment:(GCEnvironment)environment
{
    return @"assetsbaseurlbyregion";
}

- (NSString *)base64EncodedClientMetaInfo
{
    return @"base64encodedclientmetainfo";
}

@end
