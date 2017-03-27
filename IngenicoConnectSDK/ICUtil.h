//
//  ICUtil.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <IngenicoConnectSDK/ICRegion.h>
#import <IngenicoConnectSDK/ICEnvironment.h>

@interface ICUtil : NSObject

- (NSString *)base64EncodedClientMetaInfo __deprecated_msg("use method base64EncodedClientMetaInfoWithAppIdentifier:ipAddress: instead");
- (NSString *)base64EncodedClientMetaInfoWithAddedData:(NSDictionary *)addedData __deprecated_msg("use method base64EncodedClientMetaInfoWithAppIdentifier:ipAddress:addedData: instead");;
- (NSString *)base64EncodedClientMetaInfoWithAppIdentifier:(NSString *)appIdentifier;
- (NSString *)base64EncodedClientMetaInfoWithAppIdentifier:(NSString *)appIdentifier ipAddress:(NSString *)ipAddress;
- (NSString *)base64EncodedClientMetaInfoWithAppIdentifier:(NSString *)appIdentifier ipAddress:(NSString *)ipAddress addedData:(NSDictionary *)addedData;

- (NSString *)C2SBaseURLByRegion:(ICRegion)region environment:(ICEnvironment)environment;
- (NSString *)assetsBaseURLByRegion:(ICRegion)region environment:(ICEnvironment)environment;

@end
