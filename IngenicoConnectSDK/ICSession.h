//
//  ICSession.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import  "ICPaymentRequest.h"
#import  "ICBasicPaymentProducts.h"
#import  "ICC2SCommunicator.h"
#import  "ICIINDetailsResponse.h"
#import  "ICPreparedPaymentRequest.h"
#import  "ICPaymentContext.h"
#import  "ICAssetManager.h"
#import  "ICJOSEEncryptor.h"
#import  "ICDirectoryEntries.h"

@class ICBasicPaymentProductGroups;
@class ICPaymentProductGroup;

@interface ICSession : NSObject
@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSString *assetsBaseURL;

- (instancetype)initWithCommunicator:(ICC2SCommunicator *)communicator assetManager:(ICAssetManager *)assetManager encryptor:(ICEncryptor *)encryptor JOSEEncryptor:(ICJOSEEncryptor *)JOSEEncryptor stringFormatter:(ICStringFormatter *)stringFormatter;
+ (ICSession *)sessionWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId region:(ICRegion)region environment:(ICEnvironment)environment DEPRECATED_ATTRIBUTE __deprecated_msg("Use sessionWithClientSessionId:customerId:baseURL:assetBaseURL:appIdentifier:loggingEnabled: instead");
+ (ICSession *)sessionWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId region:(ICRegion)region environment:(ICEnvironment)environment appIdentifier:(NSString *)appIdentifier DEPRECATED_ATTRIBUTE __deprecated_msg("Use sessionWithClientSessionId:customerId:baseURL:assetBaseURL:appIdentifier:loggingEnabled: instead");
+ (ICSession *)sessionWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId baseURL:(NSString *)baseURL assetBaseURL:(NSString *)assetBaseURL appIdentifier:(NSString *)appIdentifier DEPRECATED_ATTRIBUTE __deprecated_msg("Use sessionWithClientSessionId:customerId:baseURL:assetBaseURL:appIdentifier:loggingEnabled: instead");
+ (ICSession *)sessionWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId baseURL:(NSString *)baseURL assetBaseURL:(NSString *)assetBaseURL appIdentifier:(NSString *)appIdentifier loggingEnabled:(BOOL)loggingEnabled;

- (void)paymentProductsForContext:(ICPaymentContext *)context success:(void (^)(ICBasicPaymentProducts *paymentProducts))success failure:(void (^)(NSError *error))failure;
- (void)paymentProductGroupsForContext:(ICPaymentContext *)context success:(void (^)(ICBasicPaymentProductGroups *paymentProductGroups))success failure:(void (^)(NSError *error))failure;
- (void)paymentItemsForContext:(ICPaymentContext *)context groupPaymentProducts:(BOOL)groupPaymentProducts success:(void (^)(ICPaymentItems *paymentItems))success failure:(void (^)(NSError *error))failure;

- (void)paymentProductWithId:(NSString *)paymentProductId context:(ICPaymentContext *)context success:(void (^)(ICPaymentProduct *paymentProduct))success failure:(void (^)(NSError *error))failure;
- (void)paymentProductGroupWithId:(NSString *)paymentProductGroupId context:(ICPaymentContext *)context success:(void (^)(ICPaymentProductGroup *paymentProductGroup))success failure:(void (^)(NSError *error))failure;

- (void)IINDetailsForPartialCreditCardNumber:(NSString *)partialCreditCardNumber context:(ICPaymentContext *)context success:(void (^)(ICIINDetailsResponse *iinDetailsResponse))success failure:(void (^)(NSError *error))failure;
- (void)convertAmount:(long)amountInCents withSource:(NSString *)source target:(NSString *)target success:(void (^)(long convertedAmountInCents))success failure:(void (^)(NSError *error))failure;
- (void)directoryForPaymentProductId:(NSString *)paymentProductId countryCode:(NSString *)countryCode currencyCode:(NSString *)currencyCode success:(void (^)(ICDirectoryEntries *directoryEntries))success failure:(void (^)(NSError *error))failure;
- (void)preparePaymentRequest:(ICPaymentRequest *)paymentRequest success:(void (^)(ICPreparedPaymentRequest *preparedPaymentRequest))success failure:(void (^)(NSError *error))failure;
- (void)paymentProductNetworksForProductId:(NSString *)paymentProductId context:(ICPaymentContext *)context success:(void (^)(ICPaymentProductNetworks *paymentProductNetworks))success failure:(void (^)(NSError *error))failure;
- (void)thirdPartyStatusForPayment:(NSString *)paymentId success:(void(^)(ICThirdPartyStatusResponse *thirdPartyStatusResponse))success failure:(void(^)(NSError *error))failure;
- (void)customerDetailsForProductId:(NSString *)productId withLookupValues:(NSArray<NSDictionary<NSString*, NSString*>*> *)values countryCode:(NSString *)countryCode success:(void (^)(ICCustomerDetails *))success failure:(void (^)(NSError *))failure;
- (BOOL)isEnvironmentTypeProduction DEPRECATED_ATTRIBUTE __deprecated_msg("This attribute is dependant on ICEnvironment, and will therefore be removed.");
- (BOOL)loggingEnabled;
- (void)setLoggingEnabled:(BOOL)loggingEnabled;

@end
