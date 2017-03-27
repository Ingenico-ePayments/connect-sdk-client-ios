//
//  ICJOSEEncryptor.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IngenicoConnectSDK/ICEncryptor.h>

@interface ICJOSEEncryptor : NSObject

- (instancetype)initWithEncryptor:(ICEncryptor *)encryptor;
- (NSString *)encryptToCompactSerialization:(NSString *)JSON withPublicKey:(SecKeyRef)publicKey keyId:(NSString *)keyId;
- (NSString *)decryptFromCompactSerialization:(NSString *)JOSE withPrivateKey:(SecKeyRef)privateKey;

@end
