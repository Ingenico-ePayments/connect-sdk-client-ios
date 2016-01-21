//
//  GCPublicKeyResponse.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 02/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCPublicKeyResponse : NSObject

@property (strong, nonatomic, readonly) NSString *keyId;
@property (strong, nonatomic, readonly) NSString *encodedPublicKey;

- (instancetype)initWithKeyId:(NSString *)keyId encodedPublicKey:(NSString *)encodedPublicKey;

@end
