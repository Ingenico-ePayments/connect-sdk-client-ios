//
//  ICSession.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <IngenicoConnectSDK/ICPaymentRequest.h>
#import <IngenicoConnectSDK/ICBasicPaymentProducts.h>
#import <IngenicoConnectSDK/ICC2SCommunicator.h>
#import <IngenicoConnectSDK/ICIINDetailsResponse.h>
#import <IngenicoConnectSDK/ICPreparedPaymentRequest.h>
#import <IngenicoConnectSDK/ICPaymentContext.h>
#import <IngenicoConnectSDK/ICAssetManager.h>
#import <IngenicoConnectSDK/ICJOSEEncryptor.h>
#import <IngenicoConnectSDK/ICDirectoryEntries.h>

@class ICBasicPaymentProductGroups;
@class ICPaymentProductGroup;

@interface ICSession : NSObject

- (instancetype)initWithCommunicator:(ICC2SCommunicator *)communicator assetManager:(ICAssetManager *)assetManager encryptor:(ICEncryptor *)encryptor JOSEEncryptor:(ICJOSEEncryptor *)JOSEEncryptor stringFormatter:(ICStringFormatter *)stringFormatter;
+ (ICSession *)sessionWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId region:(ICRegion)region environment:(ICEnvironment)environment __deprecated_msg("use sessionWithClientSessionId:customerId:region:environment:appIdentifier: instead");
+ (ICSession *)sessionWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId region:(ICRegion)region environment:(ICEnvironment)environment appIdentifier:(NSString *)appIdentifier;


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
- (BOOL)isEnvironmentTypeProduction;

@end
