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

- (NSString *)base64EncodedClientMetaInfo __deprecated_msg("use method base64EncodedClientMetaInfoWithAppIdentifier:ipAddress: instead");
- (NSString *)base64EncodedClientMetaInfoWithAddedData:(NSDictionary *)addedData __deprecated_msg("use method base64EncodedClientMetaInfoWithAppIdentifier:ipAddress:addedData: instead");;
- (NSString *)base64EncodedClientMetaInfoWithAppIdentifier:(NSString *)appIdentifier;
- (NSString *)base64EncodedClientMetaInfoWithAppIdentifier:(NSString *)appIdentifier ipAddress:(NSString *)ipAddress;
- (NSString *)base64EncodedClientMetaInfoWithAppIdentifier:(NSString *)appIdentifier ipAddress:(NSString *)ipAddress addedData:(NSDictionary *)addedData;

- (NSString *)C2SBaseURLByRegion:(GCRegion)region environment:(GCEnvironment)environment;
- (NSString *)assetsBaseURLByRegion:(GCRegion)region environment:(GCEnvironment)environment;

@end
