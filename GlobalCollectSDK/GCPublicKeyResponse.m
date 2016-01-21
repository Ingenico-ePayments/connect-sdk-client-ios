//
//  GCPublicKeyResponse.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 02/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCPublicKeyResponse.h"

@implementation GCPublicKeyResponse

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
