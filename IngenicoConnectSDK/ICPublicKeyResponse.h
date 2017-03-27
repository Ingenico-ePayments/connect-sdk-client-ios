//
//  ICPublicKeyResponse.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICPublicKeyResponse : NSObject

@property (strong, nonatomic, readonly) NSString *keyId;
@property (strong, nonatomic, readonly) NSString *encodedPublicKey;

- (instancetype)initWithKeyId:(NSString *)keyId encodedPublicKey:(NSString *)encodedPublicKey;

@end
