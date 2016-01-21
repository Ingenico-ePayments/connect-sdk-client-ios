//
//  GCEncryptor.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 17/04/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCEncryptor : NSObject

- (void)generateRSAKeyPairWithPublicTag:(NSString *)publicTagString privateTag:(NSString *)privateTagString;
- (void)storeRSAKeyPairFromPFXData:(NSData *)PFXData password:(NSString *)password publicTag:(NSString *)publicTag privateTag:(NSString *)privateTag;
- (NSData *)stripPublicKey:(NSData *)DERData;
- (void)storePublicKey:(NSData *)DERData tag:(NSString *)tag;

- (NSData *)generateRandomBytesWithLength:(size_t)length;

- (NSData *)encryptRSA:(NSData *)plaintext key:(SecKeyRef)publicKey;
- (NSData *)decryptRSA:(NSData *)cipher key:(SecKeyRef)privateKey;
- (SecKeyRef)RSAKeyWithTag:(NSString*)keyIdentifier;
- (void)deleteRSAKeyWithTag:(NSString *)tag;

- (NSData *)encryptAES:(NSData *)plaintext key:(NSData *)key IV:(NSData *)IV;
- (NSData *)decryptAES:(NSData *)ciphertext key:(NSData *)key IV:(NSData *)IV;

- (NSData *)generateHMAC:(NSData *)input key:(NSData *)key;

- (NSString *)UUID;

@end
