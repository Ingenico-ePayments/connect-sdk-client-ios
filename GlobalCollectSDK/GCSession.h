//
//  GCSession.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 02/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCPaymentRequest.h"
#import "GCPaymentProducts.h"
#import "GCC2SCommunicator.h"
#import "GCIINDetailsResponse.h"
#import "GCPreparedPaymentRequest.h"
#import "GCC2SPaymentProductContext.h"
#import "GCAssetManager.h"
#import "GCJOSEEncryptor.h"
#import "GCDirectoryEntries.h"

@interface GCSession : NSObject

- (instancetype)initWithCommunicator:(GCC2SCommunicator *)communicator assetManager:(GCAssetManager *)assetManager encryptor:(GCEncryptor *)encryptor JOSEEncryptor:(GCJOSEEncryptor *)JOSEEncryptor stringFormatter:(GCStringFormatter *)stringFormatter;
+ (GCSession *)sessionWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId region:(GCRegion)region environment:(GCEnvironment)environment;
- (void)paymentProductsForContext:(GCC2SPaymentProductContext *)context success:(void (^)(GCPaymentProducts *paymentProducts))success failure:(void (^)(NSError *error))failure;
- (void)paymentProductWithId:(NSString *)paymentProductId context:(GCC2SPaymentProductContext *)context success:(void (^)(GCPaymentProduct *paymentProduct))success failure:(void (^)(NSError *error))failure;
- (GCIINDetailsResponse *)IINDetailsForPartialCreditCardNumber:(NSString *)partialCreditCardNumber;
- (void)convertAmount:(long)amountInCents withSource:(NSString *)source target:(NSString *)target succes:(void (^)(long convertedAmountInCents))success failure:(void (^)(NSError *error))failure;
- (void)directoryForPaymentProductId:(NSString *)paymentProductId countryCode:(NSString *)countryCode currencyCode:(NSString *)currencyCode succes:(void (^)(GCDirectoryEntries *directoryEntries))success failure:(void (^)(NSError *error))failure;
- (void)preparePaymentRequest:(GCPaymentRequest *)paymentRequest success:(void (^)(GCPreparedPaymentRequest *preparedPaymentRequest))success failure:(void (^)(NSError *error))failure;

@end
