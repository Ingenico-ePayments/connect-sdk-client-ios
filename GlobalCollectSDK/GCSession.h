//
//  GCSession.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 02/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCPaymentRequest.h"
#import "GCBasicPaymentProducts.h"
#import "GCC2SCommunicator.h"
#import "GCIINDetailsResponse.h"
#import "GCPreparedPaymentRequest.h"
#import "GCPaymentContext.h"
#import "GCAssetManager.h"
#import "GCJOSEEncryptor.h"
#import "GCDirectoryEntries.h"

@class GCBasicPaymentProductGroups;
@class GCPaymentProductGroup;

@interface GCSession : NSObject

- (instancetype)initWithCommunicator:(GCC2SCommunicator *)communicator assetManager:(GCAssetManager *)assetManager encryptor:(GCEncryptor *)encryptor JOSEEncryptor:(GCJOSEEncryptor *)JOSEEncryptor stringFormatter:(GCStringFormatter *)stringFormatter;
+ (GCSession *)sessionWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId region:(GCRegion)region environment:(GCEnvironment)environment __deprecated_msg("use sessionWithClientSessionId:customerId:region:environment:appIdentifier: instead");
+ (GCSession *)sessionWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId region:(GCRegion)region environment:(GCEnvironment)environment appIdentifier:(NSString *)appIdentifier;


- (void)paymentProductsForContext:(GCPaymentContext *)context success:(void (^)(GCBasicPaymentProducts *paymentProducts))success failure:(void (^)(NSError *error))failure;
- (void)paymentProductGroupsForContext:(GCPaymentContext *)context success:(void (^)(GCBasicPaymentProductGroups *paymentProductGroups))success failure:(void (^)(NSError *error))failure;
- (void)paymentItemsForContext:(GCPaymentContext *)context groupPaymentProducts:(BOOL)groupPaymentProducts success:(void (^)(GCPaymentItems *paymentItems))success failure:(void (^)(NSError *error))failure;

- (void)paymentProductWithId:(NSString *)paymentProductId context:(GCPaymentContext *)context success:(void (^)(GCPaymentProduct *paymentProduct))success failure:(void (^)(NSError *error))failure;
- (void)paymentProductGroupWithId:(NSString *)paymentProductGroupId context:(GCPaymentContext *)context success:(void (^)(GCPaymentProductGroup *paymentProductGroup))success failure:(void (^)(NSError *error))failure;

- (void)IINDetailsForPartialCreditCardNumber:(NSString *)partialCreditCardNumber context:(GCPaymentContext *)context success:(void (^)(GCIINDetailsResponse *iinDetailsResponse))success failure:(void (^)(NSError *error))failure;
- (void)convertAmount:(long)amountInCents withSource:(NSString *)source target:(NSString *)target succes:(void (^)(long convertedAmountInCents))success failure:(void (^)(NSError *error))failure;
- (void)directoryForPaymentProductId:(NSString *)paymentProductId countryCode:(NSString *)countryCode currencyCode:(NSString *)currencyCode succes:(void (^)(GCDirectoryEntries *directoryEntries))success failure:(void (^)(NSError *error))failure;
- (void)preparePaymentRequest:(GCPaymentRequest *)paymentRequest success:(void (^)(GCPreparedPaymentRequest *preparedPaymentRequest))success failure:(void (^)(NSError *error))failure;
- (void)paymentProductNetworksForProductId:(NSString *)paymentProductId context:(GCPaymentContext *)context success:(void (^)(GCPaymentProductNetworks *paymentProductNetworks))success failure:(void (^)(NSError *error))failure;

- (BOOL)isEnvironmentTypeProduction;

@end