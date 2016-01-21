//
//  GCUtil.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 02/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCRegion.h"
#import "GCEnvironment.h"

@interface GCUtil : NSObject

- (NSString *)base64EncodedClientMetaInfo;
- (NSString *)base64EncodedClientMetaInfoWithAddedData:(NSDictionary *)addedData;
- (NSString *)C2SBaseURLByRegion:(GCRegion)region environment:(GCEnvironment)environment;
- (NSString *)assetsBaseURLByRegion:(GCRegion)region environment:(GCEnvironment)environment;

@end
