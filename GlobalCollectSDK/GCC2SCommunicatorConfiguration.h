//
//  GCC2SCommunicatorConfiguration.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 03/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCRegion.h"
#import "GCUtil.h"
#import "GCEnvironment.h"

@interface GCC2SCommunicatorConfiguration : NSObject

@property (strong, nonatomic) NSString *clientSessionId;
@property (strong, nonatomic) NSString *customerId;
@property (nonatomic) GCRegion region;
@property (nonatomic) GCEnvironment environment;

- (instancetype)initWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId region:(GCRegion)region environment:(GCEnvironment)environment util:(GCUtil *)util;
- (NSString *)baseURL;
- (NSString *)assetsBaseURL;
- (NSString *)base64EncodedClientMetaInfo;

@end
