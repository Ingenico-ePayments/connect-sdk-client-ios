//
//  GCC2SCommunicator.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 02/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCC2SCommunicatorConfiguration.h"
#import "GCC2SPaymentProductContext.h"
#import "GCPublicKeyResponse.h"
#import "GCPaymentProducts.h"
#import "GCPaymentProduct.h"
#import "GCAssetManager.h"
#import "GCStringFormatter.h"
#import "GCDirectoryEntries.h"

@interface GCC2SCommunicator : NSObject

- (instancetype)initWithConfiguration:(GCC2SCommunicatorConfiguration *)configuration;
- (void)paymentProductsForContext:(GCC2SPaymentProductContext *)context success:(void (^)(GCPaymentProducts *paymentProducts))success failure:(void (^)(NSError *error))failure;
- (void)paymentProductWithId:(NSString *)paymentProductId context:(GCC2SPaymentProductContext *)context success:(void (^)(GCPaymentProduct *paymentProduct))success failure:(void (^)(NSError *error))failure;
- (void)paymentProductIdByPartialCreditCardNumber:(NSString *)partialCreditCardNumber success:(void (^)(NSString *paymentProductId))success failure:(void (^)(NSError *error))failure;
- (void)publicKey:(void (^)(GCPublicKeyResponse *publicKeyResponse))success failure:(void (^)(NSError *error))failure;
- (void)convertAmount:(long)amountInCents withSource:(NSString *)source target:(NSString *)target succes:(void (^)(long convertedAmountInCents))success failure:(void (^)(NSError *error))failure;
- (void)directoryForPaymentProductId:(NSString *)paymentProductId countryCode:(NSString *)countryCode currencyCode:(NSString *)currencyCode succes:(void (^)(GCDirectoryEntries *directoryEntries))success failure:(void (^)(NSError *error))failure;
- (NSString *)base64EncodedClientMetaInfo;
- (NSString *)baseURL;
- (NSString *)assetsBaseURL;
- (NSString *)clientSessionId;

@end
