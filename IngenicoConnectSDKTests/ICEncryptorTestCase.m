//
//  ICEncryptorTestCase.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CommonCrypto/CommonHMAC.h>
#import  "ICEncryptor.h"
#import  "ICBase64.h"

@interface ICEncryptorTestCase : XCTestCase

@property (strong, nonatomic) ICEncryptor *encryptor;

@end

@implementation ICEncryptorTestCase

- (void)setUp
{
    [super setUp];
    self.encryptor = [[ICEncryptor alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testGenerateRSAKeyPair
{
    [self.encryptor deleteRSAKeyWithTag:@"test-public-tag"];
    [self.encryptor deleteRSAKeyWithTag:@"test-private-tag"];
    [self.encryptor generateRSAKeyPairWithPublicTag:@"test-public-tag" privateTag:@"test-private-tag"];
    SecKeyRef publicKey = [self.encryptor RSAKeyWithTag:@"test-public-tag"];
    SecKeyRef privateKey = [self.encryptor RSAKeyWithTag:@"test-private-tag"];
    XCTAssertTrue(publicKey != NULL && privateKey != NULL, @"Failed to generate a pair of RSA keys");
    [self.encryptor deleteRSAKeyWithTag:@"test-public-tag"];
    [self.encryptor deleteRSAKeyWithTag:@"test-private-tag"];
}

//- (void)testStoreKeyPair
//{
//    NSString *PFXPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"certificate" ofType:@"pfx"];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSData *PFXData = [fileManager contentsAtPath:PFXPath];
//    [self.encryptor deleteRSAKeyWithTag:@"test-public-tag"];
//    [self.encryptor deleteRSAKeyWithTag:@"test-private-tag"];
//    [self.encryptor storeRSAKeyPairFromPFXData:PFXData password:@"test" publicTag:@"test-public-tag" privateTag:@"test-private-tag"];
//    SecKeyRef publicKey = [self.encryptor RSAKeyWithTag:@"test-public-tag"];
//    SecKeyRef privateKey = [self.encryptor RSAKeyWithTag:@"test-private-tag"];
//    XCTAssertTrue(publicKey != NULL && privateKey != NULL, @"Failed to import a pair of RSA keys from a PFX certificate");
//    [self.encryptor deleteRSAKeyWithTag:@"test-public-tag"];
//    [self.encryptor deleteRSAKeyWithTag:@"test-private-tag"];
//}

- (void)testStripPublicKey
{
    ICBase64 *base64 = [[ICBase64 alloc] init];
    NSString *encodedPublicKey = @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyTyYdSLcMxpHdu7IR6/co0Fti8QyzZ//b9nBeSZaRTynjmQ2/E0SmBzWN6akGLYVL96EXHl5mdYvFKAJZfKuCkiKP29wqjemz93RrMwwNU/AYHzYpUoUTXLDzwfjnzsncx+NMpxwym6A56rZasYyrEjaTrigmduOVPlm77oDlYbK8/PfDBWthuJINo62fOCOoXxkWybtz3y2nvQ2Mhp0xQ6bF0XJ6TtlT83NFs9CZIvKLEQF2cWVsAJtuUfcBj5Nnk0xzDhcpVCMJ61Zo2K03dYZePStvZX4nyb9pLbKaqPN2G1uy7QlGftBFB8p20Zn1j5lx3G+HXKUW76hY5z4QwIDAQAB";
    NSData *publicKey = [base64 decode:encodedPublicKey];
    NSData *strippedKey = [self.encryptor stripPublicKey:publicKey];
    [self.encryptor deleteRSAKeyWithTag:@"test-public-tag"];
    [self.encryptor storePublicKey:strippedKey tag:@"test-public-tag"];
    SecKeyRef storedKey = [self.encryptor RSAKeyWithTag:@"test-public-tag"];
    XCTAssertTrue(storedKey != NULL, @"Failed to strip and store a public key");
    [self.encryptor deleteRSAKeyWithTag:@"test-public-tag"];
}

- (void)testGenerateRandomBytesWithLength
{
    NSMutableArray *dataCollection = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; ++i) {
        NSData *data = [self.encryptor generateRandomBytesWithLength:16];
        [dataCollection addObject:data];
    }
    for (int i = 0; i < 10; ++i) {
        for (int j = i + 1; j < 10; ++j) {
            NSData *data1 = dataCollection[i];
            NSData *data2 = dataCollection[j];
            if ([data1 isEqualToData:data2] == YES) {
                XCTFail(@"Generated the same random bytes more than once");
            }
        }
    }
}

//- (void)testEncryptRSA
//{
//    [self.encryptor generateRSAKeyPairWithPublicTag:@"test-public-tag" privateTag:@"test-private-tag"];
//    SecKeyRef publicKey = [self.encryptor RSAKeyWithTag:@"test-public-tag"];
//    unsigned char buffer[4];
//    buffer[0] = 0;
//    buffer[1] = 255;
//    buffer[2] = 43;
//    buffer[3] = 1;
//    NSData *input = [NSData dataWithBytes:buffer length:4];
//    NSData *output = [self.encryptor encryptRSA:input key:publicKey];
//    XCTAssertTrue([input isEqualToData:output] == NO, @"RSA encrypted data is equal to unencrypted data");
//    [self.encryptor deleteRSAKeyWithTag:@"test-public-tag"];
//    [self.encryptor deleteRSAKeyWithTag:@"test-private-tag"];
//}

//- (void)testEncryptDecryptRSA
//{
//    [self.encryptor generateRSAKeyPairWithPublicTag:@"test-public-tag" privateTag:@"test-private-tag"];
//    SecKeyRef publicKey = [self.encryptor RSAKeyWithTag:@"test-public-tag"];
//    SecKeyRef privateKey = [self.encryptor RSAKeyWithTag:@"test-private-tag"];
//    unsigned char buffer[4];
//    buffer[0] = 0;
//    buffer[1] = 255;
//    buffer[2] = 43;
//    buffer[3] = 1;
//    NSData *input = [NSData dataWithBytes:buffer length:4];
//    NSData *output = [self.encryptor encryptRSA:input key:publicKey];
//    NSData *decryptedOutput = [self.encryptor decryptRSA:output key:privateKey];
//    XCTAssert([input isEqualToData:decryptedOutput], @"Encrypted and decrypted data is not equal to initial data");
//    [self.encryptor deleteRSAKeyWithTag:@"test-public-tag"];
//    [self.encryptor deleteRSAKeyWithTag:@"test-private-tag"];
//}

- (void)testRSAKeyWithTag
{
    [self.encryptor deleteRSAKeyWithTag:@"test-public-tag"];
    [self.encryptor deleteRSAKeyWithTag:@"test-private-tag"];
    [self.encryptor generateRSAKeyPairWithPublicTag:@"test-public-tag" privateTag:@"test-private-tag"];
    SecKeyRef key = [self.encryptor RSAKeyWithTag:@"test-public-tag"];
    XCTAssertTrue(key != NULL, @"Unable to retrieve a generated key");
    [self.encryptor deleteRSAKeyWithTag:@"test-public-tag"];
    [self.encryptor deleteRSAKeyWithTag:@"test-private-tag"];
}

- (void)testDeleteRSAKeyWithTag
{
    [self.encryptor deleteRSAKeyWithTag:@"test-public-tag"];
    [self.encryptor deleteRSAKeyWithTag:@"test-private-tag"];
    [self.encryptor generateRSAKeyPairWithPublicTag:@"test-public-tag" privateTag:@"test-private-tag"];
    [self.encryptor deleteRSAKeyWithTag:@"test-public-tag"];
    [self.encryptor deleteRSAKeyWithTag:@"test-private-tag"];
    
    CFTypeRef keyRef;
    NSMutableDictionary *queryAttr = [[NSMutableDictionary alloc] init];
    
    NSData* tag = [@"test-public-tag" dataUsingEncoding:NSUTF8StringEncoding];
    
    [queryAttr setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryAttr setObject:tag forKey:(__bridge id)kSecAttrApplicationTag];
    [queryAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [queryAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    
    OSStatus error = SecItemCopyMatching((__bridge CFDictionaryRef)queryAttr, &keyRef);
    
    XCTAssertTrue(error == errSecItemNotFound, @"Retrieved a key that should not be present");
}

- (void)testEncryptAES
{
    NSData *AESKey = [self.encryptor generateRandomBytesWithLength:32];
    NSData *AESIV = [self.encryptor generateRandomBytesWithLength:32];
    unsigned char buffer[4];
    buffer[0] = 0;
    buffer[1] = 255;
    buffer[2] = 43;
    buffer[3] = 1;
    NSData *input = [NSData dataWithBytes:buffer length:4];
    NSData *output = [self.encryptor encryptAES:input key:AESKey IV:AESIV];
    XCTAssertTrue([input isEqualToData:output] == NO, @"AES encrypted data is equal to unencrypted data");
}

- (void)testEncryptDecryptAES
{
    NSData *AESKey = [self.encryptor generateRandomBytesWithLength:32];
    NSData *AESIV = [self.encryptor generateRandomBytesWithLength:32];
    unsigned char buffer[4];
    buffer[0] = 0;
    buffer[1] = 255;
    buffer[2] = 43;
    buffer[3] = 1;
    NSData *input = [NSData dataWithBytes:buffer length:4];
    NSData *encryptedInput = [self.encryptor encryptAES:input key:AESKey IV:AESIV];
    NSData *output = [self.encryptor decryptAES:encryptedInput key:AESKey IV:AESIV];
    XCTAssertTrue([input isEqualToData:output], @"AES encrypted and decrypted data is not equal to the original data");
}

- (void)testGenerateHMACLength
{
    NSData *HMACKey = [self.encryptor generateRandomBytesWithLength:16];
    unsigned char buffer[4];
    buffer[0] = 0;
    buffer[1] = 255;
    buffer[2] = 43;
    buffer[3] = 1;
    NSData *input = [NSData dataWithBytes:buffer length:4];
    NSData *HMAC = [self.encryptor generateHMAC:input key:HMACKey];
    XCTAssertTrue(HMAC.length == CC_SHA512_DIGEST_LENGTH, @"Generated HMAC has inappropriate size");
}

- (void)testGenerateHMACContent
{
    NSData *HMACKey = [self.encryptor generateRandomBytesWithLength:16];
    unsigned char buffer[4];
    buffer[0] = 0;
    buffer[1] = 255;
    buffer[2] = 43;
    buffer[3] = 1;
    NSData *input = [NSData dataWithBytes:buffer length:4];
    NSData *HMAC1 = [self.encryptor generateHMAC:input key:HMACKey];
    NSData *HMAC2 = [self.encryptor generateHMAC:input key:HMACKey];
    XCTAssertTrue([HMAC1 isEqualToData:HMAC2], @"HMAC codes generated from the same input do not match");
}

- (void)testUUID
{
    NSMutableArray *UUIDCollection = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; ++i) {
        NSString *UUID = [self.encryptor UUID];
        [UUIDCollection addObject:UUID];
    }
    for (int i = 0; i < 10; ++i) {
        for (int j = i + 1; j < 10; ++j) {
            NSString *UUID1 = UUIDCollection[i];
            NSString *UUID2 = UUIDCollection[j];
            if ([UUID1 isEqualToString:UUID2] == YES) {
                XCTFail(@"Generated the same UUID more than once");
            }
        }
    }
}

@end
