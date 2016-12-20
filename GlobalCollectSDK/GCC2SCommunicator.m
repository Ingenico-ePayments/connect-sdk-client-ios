//
//  GCC2SCommunicator.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 02/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCC2SCommunicator.h"
#import "GCBasicPaymentProductsConverter.h"
#import "GCPaymentProductConverter.h"
#import "GCDirectoryEntriesConverter.h"
#import "GCAFNetworkingWrapper.h"
#import "GCPaymentAmountOfMoney.h"
#import "GCPaymentContextConverter.h"
#import "GCIINDetailsResponseConverter.h"
#import "GCBasicPaymentProductGroups.h"
#import "GCPaymentProductGroup.h"
#import "GCPaymentProductGroupsConverter.h"
#import "GCPaymentProductGroupConverter.h"
#import "GCSDKConstants.h"
#import <PassKit/PKPaymentAuthorizationViewController.h>

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

- (BOOL)isEnvironmentTypeProduction {
    switch (self.configuration.environment) {
        case GCProduction:
            return YES;
        default:
            return NO;
    }
}

- (void)paymentProductsForContext:(GCPaymentContext *)context success:(void (^)(GCBasicPaymentProducts *paymentProducts))success failure:(void (^)(NSError *error))failure
{
    NSString *isRecurring = context.isRecurring == YES ? @"true" : @"false";
    NSString *URL = [NSString stringWithFormat:@"%@/%@/products?countryCode=%@&locale=%@&currencyCode=%@&amount=%lu&hide=fields&isRecurring=%@", [self baseURL], self.configuration.customerId, context.countryCode, context.locale, context.amountOfMoney.currencyCode, (unsigned long)context.amountOfMoney.totalAmount, isRecurring];
    [self getResponseForURL:URL succes:^(id responseObject) {
        NSArray *rawPaymentProducts = [(NSDictionary *)responseObject objectForKey:@"paymentProducts"];
        GCBasicPaymentProductsConverter *converter = [[GCBasicPaymentProductsConverter alloc] init];
        GCBasicPaymentProducts *paymentProducts = [converter paymentProductsFromJSON:rawPaymentProducts];
        [self filterAndroidPayFromProducts:paymentProducts];
        [self checkApplePayAvailabilityWithPaymentProducts:paymentProducts forContext:context success:^{
            success(paymentProducts);
        } failure:^(NSError *error) {
            failure(error);
        }];
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)filterAndroidPayFromProducts:(GCBasicPaymentProducts *)paymentProducts {
    GCBasicPaymentProduct *androidPayPaymentProduct = [paymentProducts paymentProductWithIdentifier:kGCAndroidPayIdentifier];
    if (androidPayPaymentProduct != nil) {
        [paymentProducts.paymentProducts removeObject:androidPayPaymentProduct];
    }
}

- (void)checkApplePayAvailabilityWithPaymentProducts:(GCBasicPaymentProducts *)paymentProducts forContext:(GCPaymentContext *)context success:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    GCBasicPaymentProduct *applePayPaymentProduct = [paymentProducts paymentProductWithIdentifier:kGCApplePayIdentifier];
    if (applePayPaymentProduct != nil) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") && [PKPaymentAuthorizationViewController canMakePayments]) {
            [self paymentProductNetworksForProductId:kGCApplePayIdentifier context:context success:^(GCPaymentProductNetworks *paymentProductNetworks) {
                if ([PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:paymentProductNetworks.paymentProductNetworks] == NO) {
                    [paymentProducts.paymentProducts removeObject:applePayPaymentProduct];
                }
                success();
            } failure:^(NSError *error) {
                failure(error);
            }];
        } else {
            [paymentProducts.paymentProducts removeObject:applePayPaymentProduct];
            success();
        }
    } else {
        success();
    }
}

- (void)paymentProductNetworksForProductId:(NSString *)paymentProductId context:(GCPaymentContext *)context success:(void (^)(GCPaymentProductNetworks *paymentProductNetworks))success failure:(void (^)(NSError *error))failure {
    NSString *isRecurring = context.isRecurring == YES ? @"true" : @"false";
    NSString *URL = [NSString stringWithFormat:@"%@/%@/products/%@/networks?countryCode=%@&locale=%@&currencyCode=%@&amount=%lu&hide=fields&isRecurring=%@", [self baseURL], self.configuration.customerId, paymentProductId, context.countryCode, context.locale, context.amountOfMoney.currencyCode, (unsigned long)context.amountOfMoney.totalAmount, isRecurring];
    [self getResponseForURL:URL succes:^(id responseObject) {
        NSArray *rawProductNetworks = [(NSDictionary *)responseObject objectForKey:@"networks"];
        GCPaymentProductNetworks *paymentProductNetworks = [[GCPaymentProductNetworks alloc] init];
        [paymentProductNetworks.paymentProductNetworks addObjectsFromArray:rawProductNetworks];
        success(paymentProductNetworks);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)paymentProductGroupsForContext:(GCPaymentContext *)context success:(void (^)(GCBasicPaymentProductGroups *paymentProductGroups))success failure:(void (^)(NSError *error))failure {
    NSString *isRecurring = context.isRecurring == YES ? @"true" : @"false";
    NSString *URL = [NSString stringWithFormat:@"%@/%@/productgroups?countryCode=%@&locale=%@&currencyCode=%@&amount=%lu&hide=fields&isRecurring=%@", [self baseURL], self.configuration.customerId, context.countryCode, context.locale, context.amountOfMoney.currencyCode, (unsigned long)context.amountOfMoney.totalAmount, isRecurring];
    [self getResponseForURL:URL succes:^(id responseObject) {
        NSArray *rawPaymentProductGroups = [(NSDictionary *)responseObject objectForKey:@"paymentProductGroups"];
        GCPaymentProductGroupsConverter *converter = [[GCPaymentProductGroupsConverter alloc] init];
        GCBasicPaymentProductGroups *paymentProductGroups = [converter paymentProductGroupsFromJSON:rawPaymentProductGroups];
        success(paymentProductGroups);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


- (void)paymentProductWithId:(NSString *)paymentProductId context:(GCPaymentContext *)context success:(void (^)(GCPaymentProduct *paymentProduct))success failure:(void (^)(NSError *error))failure
{
    [self checkAvailabilityForPaymentProductWithId:paymentProductId context:context success:^{
        NSString *isRecurring = context.isRecurring == YES ? @"true" : @"false";
        NSString *URL = [NSString stringWithFormat:@"%@/%@/products/%@/?countryCode=%@&locale=%@&currencyCode=%@&amount=%lu&isRecurring=%@", [self baseURL], self.configuration.customerId, paymentProductId, context.countryCode, context.locale, context.amountOfMoney.currencyCode, (unsigned long)context.amountOfMoney.totalAmount, isRecurring];
        [self getResponseForURL:URL succes:^(id responseObject) {
            NSDictionary *rawPaymentProduct = (NSDictionary *)responseObject;
            GCPaymentProductConverter *converter = [[GCPaymentProductConverter alloc] init];
            GCPaymentProduct *paymentProduct = [converter paymentProductFromJSON:rawPaymentProduct];
            success(paymentProduct);
        } failure:^(NSError *error) {
            failure(error);
        }];
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)checkAvailabilityForPaymentProductWithId:(NSString *)paymentProductId context:(GCPaymentContext *)context success:(void (^)(void))success failure:(void (^)(NSError *error))failure
{
    if ([paymentProductId isEqualToString:kGCApplePayIdentifier]) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") && [PKPaymentAuthorizationViewController canMakePayments]) {
            [self paymentProductNetworksForProductId:kGCApplePayIdentifier context:context success:^(GCPaymentProductNetworks *paymentProductNetworks) {
                if ([PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:paymentProductNetworks.paymentProductNetworks] == NO) {
                    failure([self badRequestErrorForPaymentProductId:paymentProductId context:context]);
                } else {
                    success();
                }
            } failure:^(NSError *error) {
                failure(error);
            }];
        } else {
            failure([self badRequestErrorForPaymentProductId:paymentProductId context:context]);
        }
    } else {
        success();
    }
}

- (NSError *)badRequestErrorForPaymentProductId:(NSString *)paymentProductId context:(GCPaymentContext *)context {
    
    NSString *isRecurring = context.isRecurring == YES ? @"true" : @"false";
    NSString *URL = [NSString stringWithFormat:@"%@/%@/products/%@/?countryCode=%@&locale=%@&currencyCode=%@&amount=%lu&isRecurring=%@", [self baseURL], self.configuration.customerId, paymentProductId, context.countryCode, context.locale, context.amountOfMoney.currencyCode, (unsigned long)context.amountOfMoney.totalAmount, isRecurring];
    NSDictionary *errorUserInfo = @{@"com.alamofire.serialization.response.error.response": [[NSHTTPURLResponse alloc] initWithURL:[NSURL fileURLWithPath:URL] statusCode:400 HTTPVersion:nil headerFields:@{@"Connection": @"close"}],
                                    @"NSErrorFailingURLKey": URL,
                                    @"com.alamofire.serialization.response.error.data": [NSData data],
                                    @"NSLocalizedDescription": @"Request failed: bad request (400)"};
    NSError *error = [NSError errorWithDomain:@"com.alamofire.serialization.response.error.response" code:-1011 userInfo:errorUserInfo];
    return error;
}

- (void)paymentProductGroupWithId:(NSString *)paymentProductGroupId context:(GCPaymentContext *)context success:(void (^)(GCPaymentProductGroup *paymentProductGroup))success failure:(void (^)(NSError *error))failure {
    NSString *isRecurring = context.isRecurring == YES ? @"true" : @"false";
    NSString *URL = [NSString stringWithFormat:@"%@/%@/productgroups/%@/?countryCode=%@&locale=%@&currencyCode=%@&amount=%lu&isRecurring=%@", [self baseURL], self.configuration.customerId, paymentProductGroupId, context.countryCode, context.locale, context.amountOfMoney.currencyCode, (unsigned long)context.amountOfMoney.totalAmount, isRecurring];
    [self getResponseForURL:URL succes:^(id responseObject) {
        NSDictionary *rawPaymentProductGroup = (NSDictionary *)responseObject;
        GCPaymentProductGroupConverter *converter = [[GCPaymentProductGroupConverter alloc] init];
        GCPaymentProductGroup *paymentProductGroup = [converter paymentProductGroupFromJSON:rawPaymentProductGroup];
        success(paymentProductGroup);
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
- (void)paymentProductIdByPartialCreditCardNumber:(NSString *)partialCreditCardNumber context:(GCPaymentContext *)context success:(void (^)(GCIINDetailsResponse *iinDetailsResponse))success failure:(void (^)(NSError *error))failure {
    NSString *URL = [NSString stringWithFormat:@"%@/%@/services/getIINdetails", [self baseURL], self.configuration.customerId];

    int max = (int) MIN(partialCreditCardNumber.length, 6);
    NSString *trimmedPartialCreditCardNumber = [partialCreditCardNumber substringToIndex:max];

    NSDictionary *parameters;
    GCPaymentContextConverter *converter = [[GCPaymentContextConverter alloc] init];
    if (context == nil) {
        parameters = [converter JSONFromPartialCreditCardNumber:trimmedPartialCreditCardNumber];
    }
    else {
        parameters = [converter JSONFromPaymentProductContext:context partialCreditCardNumber:trimmedPartialCreditCardNumber];
    }

    NSMutableIndexSet *additionalAcceptableStatusCodes = [[NSMutableIndexSet alloc] initWithIndex:404];

    [self postResponseForURL:URL withParameters:parameters additionalAcceptableStatusCodes:additionalAcceptableStatusCodes succes:^(id responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        GCIINDetailsResponseConverter *converter = [[GCIINDetailsResponseConverter alloc] init];
        GCIINDetailsResponse *IINDetails = [converter IINDetailsResponseFromJSON:response];
        success(IINDetails);
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
        long convertedAmountInCents = (long) [convertedAmount longLongValue];
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
