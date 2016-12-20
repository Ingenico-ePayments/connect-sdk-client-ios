//
//  GCC2SCommunicator.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 02/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCC2SCommunicatorConfiguration.h"
#import "GCPaymentContext.h"
#import "GCPublicKeyResponse.h"
#import "GCBasicPaymentProducts.h"
#import "GCPaymentProduct.h"
#import "GCAssetManager.h"
#import "GCStringFormatter.h"
#import "GCDirectoryEntries.h"
#import "GCIINDetailsResponse.h"
#import "GCPaymentProductNetworks.h"

@class GCBasicPaymentProductGroups;
@class GCPaymentProductGroup;

@interface GCC2SCommunicator : NSObject

- (instancetype)initWithConfiguration:(GCC2SCommunicatorConfiguration *)configuration;
- (void)paymentProductsForContext:(GCPaymentContext *)context success:(void (^)(GCBasicPaymentProducts *paymentProducts))success failure:(void (^)(NSError *error))failure;
- (void)paymentProductGroupsForContext:(GCPaymentContext *)context success:(void (^)(GCBasicPaymentProductGroups *paymentProductGroups))success failure:(void (^)(NSError *error))failure;
- (void)paymentProductWithId:(NSString *)paymentProductId context:(GCPaymentContext *)context success:(void (^)(GCPaymentProduct *paymentProduct))success failure:(void (^)(NSError *error))failure;
- (void)paymentProductGroupWithId:(NSString *)paymentProductGroupId context:(GCPaymentContext *)context success:(void (^)(GCPaymentProductGroup *paymentProductGroup))success failure:(void (^)(NSError *error))failure;
- (void)paymentProductIdByPartialCreditCardNumber:(NSString *)partialCreditCardNumber context:(GCPaymentContext *)context success:(void (^)(GCIINDetailsResponse *iinDetailsResponse))success failure:(void (^)(NSError *error))failure;
- (void)publicKey:(void (^)(GCPublicKeyResponse *publicKeyResponse))success failure:(void (^)(NSError *error))failure;
- (void)convertAmount:(long)amountInCents withSource:(NSString *)source target:(NSString *)target succes:(void (^)(long convertedAmountInCents))success failure:(void (^)(NSError *error))failure;
- (void)directoryForPaymentProductId:(NSString *)paymentProductId countryCode:(NSString *)countryCode currencyCode:(NSString *)currencyCode succes:(void (^)(GCDirectoryEntries *directoryEntries))success failure:(void (^)(NSError *error))failure;
- (void)paymentProductNetworksForProductId:(NSString *)paymentProductId context:(GCPaymentContext *)context success:(void (^)(GCPaymentProductNetworks *paymentProductNetworks))success failure:(void (^)(NSError *error))failure;
- (NSString *)base64EncodedClientMetaInfo;
- (NSString *)baseURL;
- (NSString *)assetsBaseURL;
- (NSString *)clientSessionId;

- (BOOL)isEnvironmentTypeProduction;

@end
