//
//  GCJOSEEncryptorTestCase.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 16/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCEncryptor.h"
#import "GCJOSEEncryptor.h"

@interface GCJOSEEncryptorTestCase : XCTestCase

@property (strong, nonatomic) GCEncryptor *encryptor;
@property (strong, nonatomic) GCJOSEEncryptor *JOSEEncryptor;
@property (nonatomic) SecKeyRef publicKey;
@property (nonatomic) SecKeyRef privateKey;

@end

@implementation GCJOSEEncryptorTestCase

- (void)setUp
{
    [super setUp];
    self.encryptor = [[GCEncryptor alloc] init];
    self.JOSEEncryptor = [[GCJOSEEncryptor alloc] initWithEncryptor:self.encryptor];
    [self.encryptor generateRSAKeyPairWithPublicTag:@"test-public-key" privateTag:@"test-private-key"];
    self.publicKey = [self.encryptor RSAKeyWithTag:@"test-public-key"];
    self.privateKey = [self.encryptor RSAKeyWithTag:@"test-private-key"];
}

- (void)tearDown
{
    [super tearDown];
    [self.encryptor deleteRSAKeyWithTag:@"test-public-key"];
    [self.encryptor deleteRSAKeyWithTag:@"test-private-key"];
}

- (void)testRevertible
{
    NSString *input = @"Will this encrypt and decrypt properly?";
    NSString *keyId = @"doesn't matter now";
    NSString *encrypted = [self.JOSEEncryptor encryptToCompactSerialization:input withPublicKey:self.publicKey keyId:keyId];
    NSString *decrypted = [self.JOSEEncryptor decryptFromCompactSerialization:encrypted withPrivateKey:self.privateKey];
    NSArray *parts = [decrypted componentsSeparatedByString:@"\n"];
    NSString *output = parts[1];
    XCTAssertTrue([input isEqualToString:output], @"String is not equal to original version after encrypting and decrypting according to the JOSE standard");
}

@end
