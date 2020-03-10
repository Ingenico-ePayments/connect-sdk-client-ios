//
//  ICPublicKeyResponse.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICPublicKeyResponse.h"

@implementation ICPublicKeyResponse

- (instancetype)initWithKeyId:(NSString *)keyId encodedPublicKey:(NSString *)encodedPublicKey
{
    self = [super init];
    if (self != nil) {
        _keyId = keyId;
        _encodedPublicKey = encodedPublicKey;
    }
    return self;
}

@end
