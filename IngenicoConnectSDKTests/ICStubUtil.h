//
//  ICStubUtil.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <IngenicoConnectSDK/ICUtil.h>

@interface ICStubUtil : ICUtil

- (NSString *)C2SBaseURLByRegion:(ICRegion)region environment:(ICEnvironment)environment;
- (NSString *)assetsBaseURLByRegion:(ICRegion)region environment:(ICEnvironment)environment;
- (NSString *)base64EncodedClientMetaInfo;

@end
