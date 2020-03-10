//
//  ICJOSEEncryptor.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICJOSEEncryptor.h"
#import  "ICBase64.h"

@interface ICJOSEEncryptor ()

@property (strong, nonatomic) ICEncryptor *encryptor;
@property (strong, nonatomic) ICBase64 *base64;

@end

@implementation ICJOSEEncryptor

- (instancetype)init
{
    ICEncryptor *encryptor = [[ICEncryptor alloc] init];
    self = [self initWithEncryptor:encryptor];
    return self;
}

- (instancetype)initWithEncryptor:(ICEncryptor *)encryptor
{
    self = [super init];
    if (self != nil) {
        self.encryptor = encryptor;
        self.base64 = [[ICBase64 alloc] init];
    }
    return self;
}

- (NSString *)generateProtectedHeader:(NSString *)keyId
{
    NSString *header = [NSString stringWithFormat:@"{\"alg\":\"RSA-OAEP\", \"enc\":\"A256CBC-HS512\", \"kid\":\"%@\"}", keyId];
    return header;
}

- (NSString *)encryptToCompactSerialization:(NSString *)JSON withPublicKey:(SecKeyRef)publicKey keyId:(NSString *)keyId
{
    NSString *encodedProtectedHeader = [self.base64 URLEncode:[[self generateProtectedHeader:keyId] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *AESKey = [self.encryptor generateRandomBytesWithLength:32];
    NSData *HMACKey = [self.encryptor generateRandomBytesWithLength:32];

    NSMutableData *key = [HMACKey mutableCopy];
    [key appendData:AESKey];
    NSData *encryptedKey = [self.encryptor encryptRSA:key key:publicKey];
    NSString *encodedKey = [self.base64 URLEncode:encryptedKey];
    
    NSData *IV = [self.encryptor generateRandomBytesWithLength:16];
    NSString *encodedIV = [self.base64 URLEncode:IV];
    
    NSData *additionalAuthenticatedData = [encodedProtectedHeader dataUsingEncoding:NSASCIIStringEncoding];
    NSData *AL = [self computeAL:additionalAuthenticatedData];
    
    NSData *ciphertext = [self.encryptor encryptAES:[JSON dataUsingEncoding:NSUTF8StringEncoding] key:AESKey IV:IV];
    NSString *encodedCiphertext = [self.base64 URLEncode:ciphertext];
    
    NSMutableData *authenticationData = [additionalAuthenticatedData mutableCopy];
    [authenticationData appendData:IV];
    [authenticationData appendData:ciphertext];
    [authenticationData appendData:AL];
    NSData *authenticationTag = [self.encryptor generateHMAC:authenticationData key:HMACKey];
    NSData *truncatedAuthenticationTag = [authenticationTag subdataWithRange:NSMakeRange(0, 32)];
    NSString *encodedAuthenticationTag = [self.base64 URLEncode:truncatedAuthenticationTag];
    
    NSArray *components = @[encodedProtectedHeader, encodedKey, encodedIV, encodedCiphertext, encodedAuthenticationTag];
    NSString *concatenatedComponents = [components componentsJoinedByString:@"."];

    return concatenatedComponents;
}

- (NSString *)decryptFromCompactSerialization:(NSString *)JOSE withPrivateKey:(SecKeyRef)privateKey
{
    NSArray *components = [JOSE componentsSeparatedByString:@"."];
    NSMutableString *decrypted = [[NSMutableString alloc] init];
    
    NSString *decodedProtectedHeader = [[NSString alloc] initWithData:[self.base64 URLDecode:components[0]] encoding:NSUTF8StringEncoding];
    [decrypted appendString:decodedProtectedHeader];
    
    NSData *encryptedKeys = [self.base64 URLDecode:components[1]];
    NSData *decryptedKeys = [self.encryptor decryptRSA:encryptedKeys key:privateKey];
    NSData *HMACKey = [decryptedKeys subdataWithRange:NSMakeRange(0, 32)];
    NSData *AESKey = [decryptedKeys subdataWithRange:NSMakeRange(32, 32)];
        
    NSData *IV = [self.base64 URLDecode:components[2]];
    
    NSData *ciphertext = [self.base64 URLDecode:components[3]];
    NSData *plaintext = [self.encryptor decryptAES:ciphertext key:AESKey IV:IV];
    NSString *JSON = [[NSString alloc] initWithData:plaintext encoding:NSUTF8StringEncoding];
    [decrypted appendString:@"\n"];
    if (JSON != nil) {
        [decrypted appendString:JSON];
    } else {
        [decrypted appendString:@""];
    }
        
    NSData *additionalAuthenticatedData = [components[0] dataUsingEncoding:NSASCIIStringEncoding];
    NSData *AL = [self computeAL:additionalAuthenticatedData];
    NSMutableData *authenticationData = [additionalAuthenticatedData mutableCopy];
    [authenticationData appendData:IV];
    [authenticationData appendData:ciphertext];
    [authenticationData appendData:AL];
    NSData *authenticationTag = [self.encryptor generateHMAC:authenticationData key:HMACKey];
    NSData *truncatedAuthenticationTag = [authenticationTag subdataWithRange:NSMakeRange(0, 32)];
    NSString *encodedAuthenticationTag = [self.base64 URLEncode:truncatedAuthenticationTag];
        
    [decrypted appendString:@"\n"];
    if ([encodedAuthenticationTag isEqualToString:components[4]] == YES) {
        [decrypted appendString:@"Authentication was successful"];
    } else {
        [decrypted appendString:@"Authentication failed"];
    }

    return decrypted;
}

- (NSData *)computeAL:(NSData *)data
{
    uint64_t lengthInBits = data.length * 8;
    NSData *AL = [self dataFromNumber:lengthInBits];
    return AL;
}

- (NSData *)dataFromNumber:(uint64_t)number
{
    NSMutableData *data = [[NSMutableData alloc] init];
    for (int i = 7; i >= 0; --i) {
        Byte b = (number >> (i * 8)) & 0xFF;
        [data appendBytes:&b length:1];
    }
    return data;
}

@end
