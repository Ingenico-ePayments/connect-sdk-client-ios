//
//  GCJOSEEncryptor.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 24/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCEncryptor.h"

@interface GCJOSEEncryptor : NSObject

- (instancetype)initWithEncryptor:(GCEncryptor *)encryptor;
- (NSString *)encryptToCompactSerialization:(NSString *)JSON withPublicKey:(SecKeyRef)publicKey keyId:(NSString *)keyId;
- (NSString *)decryptFromCompactSerialization:(NSString *)JOSE withPrivateKey:(SecKeyRef)privateKey;

@end
