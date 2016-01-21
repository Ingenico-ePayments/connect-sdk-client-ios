//
//  GCC2SCommunicator.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 02/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCMacros.h"
#import "GCC2SCommunicator.h"
#import "GCPaymentProductsConverter.h"
#import "GCPaymentProductConverter.h"
#import "GCDirectoryEntriesConverter.h"
#import "GCAFNetworkingWrapper.h"

@interface GCC2SCommunicator ()

@property (strong, nonatomic) GCC2SCommunicatorConfiguration *configuration;
@property (strong, nonatomic) GCAFNetworkingWrapper *afNetworkingWrapper;

@end

@implementation GCC2SCommunicator

- (instancetype)initWithConfiguration:(GCC2SCommunicatorConfiguration *)configuration
{
    self = [super init];
    if (self != nil) {
        self.configuration = configuration;
        self.afNetworkingWrapper = [[GCAFNetworkingWrapper alloc] init];
    }
    return self;
}

- (void)paymentProductsForContext:(GCC2SPaymentProductContext *)context success:(void (^)(GCPaymentProducts *paymentProducts))success failure:(void (^)(NSError *error))failure
{
    NSString *isRecurring = context.isRecurring == YES ? @"true" : @"false";
    NSString *URL = [NSString stringWithFormat:@"%@/%@/products?countryCode=%@&currencyCode=%@&amount=%lu&hide=fields&isRecurring=%@", [self baseURL], self.configuration.customerId, context.countryCode, context.currencyCode, (unsigned long)context.totalAmount, isRecurring];
    [self getResponseForURL:URL succes:^(id responseObject) {
        NSArray *rawPaymentProducts = [(NSDictionary *)responseObject objectForKey:@"paymentProducts"];
        GCPaymentProductsConverter *converter = [[GCPaymentProductsConverter alloc] init];
        GCPaymentProducts *paymentProducts = [converter paymentProductsFromJSON:rawPaymentProducts];
        success(paymentProducts);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)paymentProductWithId:(NSString *)paymentProductId context:(GCC2SPaymentProductContext *)context success:(void (^)(GCPaymentProduct *paymentProduct))success failure:(void (^)(NSError *error))failure
{
    NSString *isRecurring = context.isRecurring == YES ? @"true" : @"false";
    NSString *URL = [NSString stringWithFormat:@"%@/%@/products/%@/?countryCode=%@&currencyCode=%@&amount=%lu&isRecurring=%@", [self baseURL], self.configuration.customerId, paymentProductId, context.countryCode, context.currencyCode, (unsigned long)context.totalAmount, isRecurring];
    [self getResponseForURL:URL succes:^(id responseObject) {
        NSDictionary *rawPaymentProduct = (NSDictionary *)responseObject;
        GCPaymentProductConverter *converter = [[GCPaymentProductConverter alloc] init];
        GCPaymentProduct *paymentProduct = [converter paymentProductFromJSON:rawPaymentProduct];
        success(paymentProduct);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)publicKey:(void (^)(GCPublicKeyResponse *publicKeyResponse))success failure:(void (^)(NSError *error))failure
{
    NSString *URL = [NSString stringWithFormat:@"%@/%@/crypto/publickey", [self baseURL], self.configuration.customerId];
    [self getResponseForURL:URL succes:^(id responseObject) {
        NSDictionary *rawPublicKeyResponse = (NSDictionary *)responseObject;
        NSString *keyId = [rawPublicKeyResponse objectForKey:@"keyId"];
        NSString *encodedPublicKey = [rawPublicKeyResponse objectForKey:@"publicKey"];
        GCPublicKeyResponse *response = [[GCPublicKeyResponse alloc] initWithKeyId:keyId encodedPublicKey:encodedPublicKey];
        success(response);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)paymentProductIdByPartialCreditCardNumber:(NSString *)partialCreditCardNumber success:(void (^)(NSString *paymentProductId))success failure:(void (^)(NSError *error))failure
{
    NSString *URL = [NSString stringWithFormat:@"%@/%@/services/getIINdetails", [self baseURL], self.configuration.customerId];
    
    int max = (int) MIN(partialCreditCardNumber.length, 6);
    NSString *trimmedPartialCreditCardNumber = [partialCreditCardNumber substringToIndex:max];
    NSDictionary *parameters = @{@"bin": trimmedPartialCreditCardNumber};
    
    NSMutableIndexSet *additionalAcceptableStatusCodes = [[NSMutableIndexSet alloc] initWithIndex:404];
    
    [self postResponseForURL:URL withParameters:parameters additionalAcceptableStatusCodes:additionalAcceptableStatusCodes succes:^(id responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        NSNumber *paymentProductId = [response objectForKey:@"paymentProductId"];
        NSString *paymentProductIdAsString;
        if (paymentProductId == nil) {
            paymentProductIdAsString = @"";
        } else {
            paymentProductIdAsString = [NSString stringWithFormat:@"%@", paymentProductId];
        }
        success(paymentProductIdAsString);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)convertAmount:(long)amountInCents withSource:(NSString *)source target:(NSString *)target succes:(void (^)(long convertedAmountInCents))success failure:(void (^)(NSError *error))failure
{
    NSString *amount = [NSString stringWithFormat:@"%ld", (long) amountInCents];
    NSString *URL = [NSString stringWithFormat:@"%@/%@/services/convert/amount?source=%@&target=%@&amount=%@", [self baseURL], self.configuration.customerId, source, target, amount];
    [self getResponseForURL:URL succes:^(id responseObject) {
        NSDictionary *rawConvertResponse = (NSDictionary *)responseObject;
        NSString *convertedAmount = [rawConvertResponse objectForKey:@"convertedAmount"];
        long convertedAmountInCents = [convertedAmount longLongValue];
        success(convertedAmountInCents);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)directoryForPaymentProductId:(NSString *)paymentProductId countryCode:(NSString *)countryCode currencyCode:(NSString *)currencyCode succes:(void (^)(GCDirectoryEntries *directoryEntries))success failure:(void (^)(NSError *error))failure
{
    NSString *URL = [NSString stringWithFormat:@"%@/%@/products/%@/directory?countryCode=%@&currencyCode=%@", [self baseURL], self.configuration.customerId, paymentProductId, countryCode, currencyCode];
    [self getResponseForURL:URL succes:^(id responseObject) {
        NSArray *rawDirectoryEntries = [(NSDictionary *)responseObject objectForKey:@"entries"];
        GCDirectoryEntriesConverter *converter = [[GCDirectoryEntriesConverter alloc] init];
        GCDirectoryEntries *directoryEntries = [converter directoryEntriesFromJSON:rawDirectoryEntries];
        success(directoryEntries);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (NSDictionary *)headers
{
    NSDictionary *headers = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"GCS v1Client:%@", self.clientSessionId], @"Authorization", self.base64EncodedClientMetaInfo, @"X-GCS-ClientMetaInfo", nil];
    return headers;
}

- (void)getResponseForURL:(NSString *)URL succes:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    [self.afNetworkingWrapper getResponseForURL:URL headers:[self headers] additionalAcceptableStatusCodes:nil succes:success failure:failure];
}

- (void)postResponseForURL:(NSString *)URL withParameters:(NSDictionary *)parameters additionalAcceptableStatusCodes:(NSIndexSet *)additionalAcceptableStatusCodes succes:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    [self.afNetworkingWrapper postResponseForURL:URL headers:[self headers] withParameters:parameters additionalAcceptableStatusCodes:additionalAcceptableStatusCodes succes:success failure:failure];
}

- (NSString *)baseURL
{
    return [self.configuration baseURL];
}

- (NSString *)assetsBaseURL
{
    return [self.configuration assetsBaseURL];
}

- (NSString *)base64EncodedClientMetaInfo
{
    return [self.configuration base64EncodedClientMetaInfo];
}

- (NSString *)clientSessionId
{
    return [self.configuration clientSessionId];
}

@end
