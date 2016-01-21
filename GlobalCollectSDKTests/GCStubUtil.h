//
//  GCStubUtil.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 17/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCUtil.h"

@interface GCStubUtil : GCUtil

- (NSString *)C2SBaseURLByRegion:(GCRegion)region environment:(GCEnvironment)environment;
- (NSString *)assetsBaseURLByRegion:(GCRegion)region environment:(GCEnvironment)environment;
- (NSString *)base64EncodedClientMetaInfo;

@end
