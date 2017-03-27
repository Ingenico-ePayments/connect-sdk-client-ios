//
//  CEncryptor.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <IngenicoConnectSDK/ICEncryptor.h>
#import <IngenicoConnectSDK/ICMacros.h>

#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation ICEncryptor

#pragma mark Methods related to RSA

- (void)generateRSAKeyPairWithPublicTag:(NSString *)publicTag privateTag:(NSString *)privateTag
{
	NSMutableDictionary *privateKeyAttr = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *publicKeyAttr = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *keyPairAttr = [[NSMutableDictionary alloc] init];
	
	NSData *publicTagData = [publicTag dataUsingEncoding:NSUTF8StringEncoding];
	NSData *privateTagData = [privateTag dataUsingEncoding:NSUTF8StringEncoding];
	
	SecKeyRef publicKey = NULL;
	SecKeyRef privateKey = NULL;
	
	[privateKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
	[privateKeyAttr setObject:privateTagData forKey:(__bridge id)kSecAttrApplicationTag];
	[publicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
	[publicKeyAttr setObject:publicTagData forKey:(__bridge id)kSecAttrApplicationTag];
	[keyPairAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
	[keyPairAttr setObject:[NSNumber numberWithInt:2048] forKey:(__bridge id)kSecAttrKeySizeInBits];
	[keyPairAttr setObject:privateKeyAttr forKey:(__bridge id)kSecPrivateKeyAttrs];
	[keyPairAttr setObject:publicKeyAttr forKey:(__bridge id)kSecPublicKeyAttrs];
	
	OSStatus status = SecKeyGeneratePair((__bridge CFDictionaryRef)keyPairAttr, &publicKey, &privateKey);

    if (status != noErr) {
        DLog(@"Error while generating pair of RSA keys: %d.", (int)status);
    }
	
	if (publicKey != NULL) CFRelease(publicKey);
	if (privateKey != NULL) CFRelease(privateKey);
}


- (SecKeyRef)RSAKeyWithTag:(NSString*)keyIdentifier
{
    CFTypeRef keyRef;
    NSMutableDictionary *queryAttr = [[NSMutableDictionary alloc] init];
    
    NSData* tag = [keyIdentifier dataUsingEncoding:NSUTF8StringEncoding];
    
    [queryAttr setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryAttr setObject:tag forKey:(__bridge id)kSecAttrApplicationTag];
    [queryAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [queryAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    
    OSStatus error = SecItemCopyMatching((__bridge CFDictionaryRef)queryAttr, &keyRef);
    
    if (error != noErr) {
        DLog(@"Error while retrieving key with tag %@: %d.", keyIdentifier, (int)error);
    }
    
    return (SecKeyRef)keyRef;
}

- (void)deleteRSAKeyWithTag:(NSString *)tag
{
	NSMutableDictionary *keyAttr = [[NSMutableDictionary alloc] init];
	
	NSData *tagData = [tag dataUsingEncoding:NSUTF8StringEncoding];
    
    [keyAttr setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [keyAttr setObject:tagData forKey:(__bridge id)kSecAttrApplicationTag];
    [keyAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
	OSStatus deleteStatus = SecItemDelete((__bridge CFDictionaryRef)keyAttr);
    
    if (deleteStatus != noErr) {
        if (deleteStatus != errSecItemNotFound) {
            DLog(@"Error while deleting the key with tag %@: %d.", tag, (int)deleteStatus);
        }
    }
}

- (NSData *)encryptRSA:(NSData *)plaintext key:(SecKeyRef)publicKey
{
  // The following line throws a EXC_BAD_ACCESS when code signing is not setup properly.
  size_t cipherBufferSize = SecKeyGetBlockSize(publicKey);
	uint8_t *cipherBuffer = malloc(cipherBufferSize);
	SecKeyEncrypt(publicKey, kSecPaddingOAEP, plaintext.bytes, plaintext.length, cipherBuffer, &cipherBufferSize);
	NSData *encryptedData = [NSData dataWithBytes:cipherBuffer length:cipherBufferSize];
    free(cipherBuffer);

	return encryptedData;
}

- (NSData *)decryptRSA:(NSData *)ciphertext key:(SecKeyRef)privateKey
{
	size_t plainBufferSize = SecKeyGetBlockSize(privateKey);
	uint8_t *plainBuffer = malloc(plainBufferSize);
	SecKeyDecrypt(privateKey, kSecPaddingOAEP, ciphertext.bytes, ciphertext.length, plainBuffer, &plainBufferSize);
	NSData *decryptedData = [NSData dataWithBytes:plainBuffer length:plainBufferSize];
    free(plainBuffer);

    return decryptedData;
}

#pragma mark Importing RSA keys

// A PFX file suited to test the following methods can be generated with the following commands:
// - openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout privateKey.key -out certificate.crt
// - openssl pkcs12 -export -out certificate.pfx -inkey privatekey.key -in certificate.crt

- (void)storeRSAKeyPairFromPFXData:(NSData *)PFXData password:(NSString *)password publicTag:(NSString *)publicTag privateTag:(NSString *)privateTag
{
    SecKeyRef privateKey = NULL;
    SecKeyRef publicKey = NULL;
    NSDictionary *options = @{(__bridge id)kSecImportExportPassphrase: password};
    CFArrayRef items = NULL;
    
    OSStatus importStatus = SecPKCS12Import((__bridge CFDataRef)PFXData, (__bridge CFDictionaryRef)options, &items);
    if (importStatus == noErr && CFArrayGetCount(items) > 0) {
        CFDictionaryRef identities = CFArrayGetValueAtIndex(items, 0);
        SecIdentityRef identity = (SecIdentityRef)CFDictionaryGetValue(identities, kSecImportItemIdentity);
    
        OSStatus copyPrivateKeyStatus = SecIdentityCopyPrivateKey(identity, &privateKey);
        if (copyPrivateKeyStatus != noErr) {
            DLog(@"Error while copying private key: %d", (int)copyPrivateKeyStatus);
        }

        SecCertificateRef certificate = NULL;
        OSStatus certificateStatus = SecIdentityCopyCertificate(identity, &certificate);
        if (certificateStatus == noErr) {
            SecPolicyRef policy = NULL;
            policy = SecPolicyCreateBasicX509();
            
            SecTrustRef trust = NULL;
            SecTrustCreateWithCertificates((CFTypeRef)certificate, policy, &trust);

            SecTrustResultType result;
            OSStatus evaluateTrustStatus = SecTrustEvaluate(trust, &result);
            if (evaluateTrustStatus == noErr) {
                publicKey = SecTrustCopyPublicKey(trust);
            } else {
                DLog(@"Error while evaluating trust status: %d", (int)evaluateTrustStatus);
            }
            
            if (policy != NULL) CFRelease(policy);
            if (trust != NULL) CFRelease(trust);
        } else {
            DLog(@"Error while copying certificate: %d", (int)certificateStatus);
        }
        
        if (certificate != NULL) CFRelease(certificate);
    } else {
        DLog(@"Unable to import PKCS #12 data: %d.", (int)importStatus);
    }
    
    if (publicKey != NULL) {
        [self storeRSAKey:publicKey tag:publicTag];
        CFRelease(publicKey);
    }
    if (privateKey != NULL) {
        [self storeRSAKey:privateKey tag:privateTag];
        CFRelease(privateKey);
    }
    if (items) {
        CFRelease(items);
    }
}

- (void)storeRSAKey:(SecKeyRef)key tag:(NSString *)tag
{
    NSMutableDictionary *keyAttr = [[NSMutableDictionary alloc] init];
    
    [keyAttr setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [keyAttr setObject:tag forKey:(__bridge id)kSecAttrApplicationTag];
    [keyAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [keyAttr setObject:(__bridge id)key forKey:(__bridge id)kSecValueRef];

    OSStatus addStatus = SecItemAdd((__bridge CFDictionaryRef)keyAttr, NULL);

    if (addStatus != noErr) {
        DLog(@"Error while adding key: %d.", (int)addStatus);
    }
}

- (void)storePublicKey:(NSData *)DERData tag:(NSString *)tag
{
    NSMutableDictionary *keyAttr = [[NSMutableDictionary alloc] init];

    [keyAttr setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [keyAttr setObject:tag forKey:(__bridge id)kSecAttrApplicationTag];
    [keyAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [keyAttr setObject:(__bridge id)kSecAttrKeyClassPublic forKey:(__bridge id)kSecAttrKeyClass];
    [keyAttr setObject:DERData forKey:(__bridge id)kSecValueData];

    OSStatus addStatus = SecItemAdd((__bridge CFDictionaryRef) keyAttr, NULL);

    if (addStatus != noErr) {
        DLog(@"Error while adding key: %d", (int)addStatus);
    }
}

- (NSData *)stripPublicKey:(NSData *)DERData
{
    const int prefixLength = 24;
    uint8_t prefix[prefixLength] = {0x30, 0x82, 0x01, 0x22, 0x30, 0x0D, 0x06, 0x09, 0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0F, 0x00};

    uint8_t buffer[DERData.length];
    [DERData getBytes:buffer length:DERData.length];
    
    for (int i = 0; i < prefixLength; ++i) {
        if (prefix[i] != buffer[i]) {
            DLog(@"The provided data has an unexpected format");
            return nil;
        }
    }
    NSData *subdata = [DERData subdataWithRange:NSMakeRange(prefixLength, DERData.length - prefixLength)];
    return subdata;
}

#pragma mark Methods related to AES

- (NSData *)encryptAES:(NSData *)plaintext key:(NSData *)key IV:(NSData *)IV
{
    NSData *ciphertext = [self performAESOperation:kCCEncrypt data:plaintext key:key IV:IV];
    return ciphertext;
}

- (NSData *)decryptAES:(NSData *)ciphertext key:(NSData *)key IV:(NSData *)IV
{
    NSData *plaintext = [self performAESOperation:kCCDecrypt data:ciphertext key:key IV:IV];
    return plaintext;
}

- (NSData *)performAESOperation:(CCOperation)operation data:(NSData *)data key:(NSData *)key IV:(NSData *)IV
{
    NSMutableData *transformedData = [NSMutableData dataWithLength:data.length + kCCBlockSizeAES128];
    size_t outLength;

    CCCryptorStatus result =
        CCCrypt(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding, key.bytes, key.length, IV.bytes, data.bytes, data.length, transformedData.mutableBytes, transformedData.length, &outLength);

    if (result == kCCSuccess) {
        transformedData.length = outLength;
    } else {
        DLog(@"Error while performing AES Operation: %d.", (int)result);
        return nil;
    }
    
    return transformedData;
}

#pragma mark HMAC

- (NSData *)generateHMAC:(NSData *)input key:(NSData *)key
{
    NSMutableData *HMAC = [NSMutableData dataWithLength:CC_SHA512_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA512, key.bytes, key.length, input.bytes, input.length, HMAC.mutableBytes);

    return HMAC;
}

#pragma mark Auxiliary methods

- (NSData *)generateRandomBytesWithLength:(size_t)length
{
    NSMutableData *data = [NSMutableData dataWithLength:length];
    int result = SecRandomCopyBytes(kSecRandomDefault, length, data.mutableBytes);
    NSAssert(result == 0, @"Unable to generate random bytes: %d", errno);
    return data;
}

#pragma mark UUID

// This method is based on an answer by Abizem (http://stackoverflow.com/users/41116/abizern)
// on StackOverflow (http://stackoverflow.com/questions/8684551/generate-a-uuid-string-with-arc-enabled)

- (NSString *)UUID
{
    CFUUIDRef UUID = CFUUIDCreate(kCFAllocatorDefault);
    NSString *UUIDString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, UUID);
    CFRelease(UUID);
    return UUIDString;
}

@end
