//
//  ICC2SCommunicator.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  "ICC2SCommunicatorConfiguration.h"
#import  "ICPaymentContext.h"
#import  "ICPublicKeyResponse.h"
#import  "ICBasicPaymentProducts.h"
#import  "ICPaymentProduct.h"
#import  "ICAssetManager.h"
#import  "ICStringFormatter.h"
#import  "ICDirectoryEntries.h"
#import  "ICIINDetailsResponse.h"
#import  "ICPaymentProductNetworks.h"

@class ICBasicPaymentProductGroups;
@class ICPaymentProductGroup;
@class ICThirdPartyStatusResponse;
@interface ICC2SCommunicator : NSObject

- (instancetype)initWithConfiguration:(ICC2SCommunicatorConfiguration *)configuration;
- (void)paymentProductsForContext:(ICPaymentContext *)context success:(void (^)(ICBasicPaymentProducts *paymentProducts))success failure:(void (^)(NSError *error))failure;
- (void)paymentProductGroupsForContext:(ICPaymentContext *)context success:(void (^)(ICBasicPaymentProductGroups *paymentProductGroups))success failure:(void (^)(NSError *error))failure;
- (void)paymentProductWithId:(NSString *)paymentProductId context:(ICPaymentContext *)context success:(void (^)(ICPaymentProduct *paymentProduct))success failure:(void (^)(NSError *error))failure;
- (void)paymentProductGroupWithId:(NSString *)paymentProductGroupId context:(ICPaymentContext *)context success:(void (^)(ICPaymentProductGroup *paymentProductGroup))success failure:(void (^)(NSError *error))failure;
- (void)paymentProductIdByPartialCreditCardNumber:(NSString *)partialCreditCardNumber context:(ICPaymentContext *)context success:(void (^)(ICIINDetailsResponse *iinDetailsResponse))success failure:(void (^)(NSError *error))failure;
- (void)publicKey:(void (^)(ICPublicKeyResponse *publicKeyResponse))success failure:(void (^)(NSError *error))failure;
- (void)convertAmount:(long)amountInCents withSource:(NSString *)source target:(NSString *)target success:(void (^)(long convertedAmountInCents))success failure:(void (^)(NSError *error))failure;
- (void)directoryForPaymentProductId:(NSString *)paymentProductId countryCode:(NSString *)countryCode currencyCode:(NSString *)currencyCode success:(void (^)(ICDirectoryEntries *directoryEntries))success failure:(void (^)(NSError *error))failure;
- (void)paymentProductNetworksForProductId:(NSString *)paymentProductId context:(ICPaymentContext *)context success:(void (^)(ICPaymentProductNetworks *paymentProductNetworks))success failure:(void (^)(NSError *error))failure;
- (void)thirdPartyStatusForPayment:(NSString *)paymentId success:(void(^)(ICThirdPartyStatusResponse *thirdPartyStatusResponse))success failure:(void(^)(NSError *error))failure;
- (NSString *)base64EncodedClientMetaInfo;
- (NSString *)baseURL;
- (NSString *)assetsBaseURL;
- (NSString *)clientSessionId;
- (BOOL)loggingEnabled;
- (void)setLoggingEnabled:(BOOL)loggingEnabled;

- (BOOL)isEnvironmentTypeProduction DEPRECATED_ATTRIBUTE __deprecated_msg("This attribute is dependant on ICEnvironment, and will therefore be removed.");

@end
