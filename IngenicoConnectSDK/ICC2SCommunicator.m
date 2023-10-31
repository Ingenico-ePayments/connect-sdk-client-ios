//
//  ICC2SCommunicator.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICC2SCommunicator.h"
#import  "ICBasicPaymentProductsConverter.h"
#import  "ICPaymentProductConverter.h"
#import  "ICDirectoryEntriesConverter.h"
#import  "ICNetworkingWrapper.h"
#import  "ICPaymentAmountOfMoney.h"
#import  "ICPaymentContextConverter.h"
#import  "ICIINDetailsResponseConverter.h"
#import  "ICBasicPaymentProductGroups.h"
#import  "ICPaymentProductGroup.h"
#import  "ICPaymentProductGroupsConverter.h"
#import  "ICPaymentProductGroupConverter.h"
#import  "ICSDKConstants.h"
#import  "ICThirdPartyStatusResponse.h"
#import  "ICThirdPartyStatusResponseConverter.h"
#import <PassKit/PKPaymentAuthorizationViewController.h>
#import  "ICCustomerDetails.h"
@interface ICC2SCommunicator ()

@property (strong, nonatomic) ICC2SCommunicatorConfiguration *configuration;
@property (strong, nonatomic) ICNetworkingWrapper *networkingWrapper;

@end

@implementation ICC2SCommunicator

- (instancetype)initWithConfiguration:(ICC2SCommunicatorConfiguration *)configuration
{
    self = [super init];
    if (self != nil) {
        self.configuration = configuration;
        self.networkingWrapper = [[ICNetworkingWrapper alloc] init];
    }
    return self;
}

- (BOOL)isEnvironmentTypeProduction {
    switch (self.configuration.environment) {
        case ICProduction:
            return YES;
        default:
            return NO;
    }
}
- (void)thirdPartyStatusForPayment:(NSString *)paymentId success:(void(^)(ICThirdPartyStatusResponse *thirdPartyStatusResponse))success failure:(void(^)(NSError *error))failure
{
    NSString *url = [NSString stringWithFormat:@"%@/%@/payments/%@/thirdpartystatus", self.baseURL, self.configuration.customerId, paymentId];
    [self getResponseForURL:url success:^(id responseObject) {
        ICThirdPartyStatusResponseConverter *converter = [[ICThirdPartyStatusResponseConverter alloc] init];
        ICThirdPartyStatusResponse *response = [converter thirdPartyResponseFromJSON:(NSDictionary *)responseObject];
        success(response);
    } failure:^(NSError *error) {
        failure(error);
    }];

}
- (void)paymentProductsForContext:(ICPaymentContext *)context success:(void (^)(ICBasicPaymentProducts *paymentProducts))success failure:(void (^)(NSError *error))failure
{
    NSString *isRecurring = context.isRecurring == YES ? @"true" : @"false";
    NSString *URL = [NSString stringWithFormat:@"%@/%@/products?countryCode=%@&locale=%@&currencyCode=%@&amount=%lu&hide=fields&isRecurring=%@", [self baseURL], self.configuration.customerId, context.countryCode, context.locale, context.amountOfMoney.currencyCode, (unsigned long)context.amountOfMoney.totalAmount, isRecurring];
    [self getResponseForURL:URL success:^(id responseObject) {
        NSArray *rawPaymentProducts = [(NSDictionary *)responseObject objectForKey:@"paymentProducts"];
        ICBasicPaymentProductsConverter *converter = [[ICBasicPaymentProductsConverter alloc] init];
        ICBasicPaymentProducts *paymentProducts = [converter paymentProductsFromJSON:rawPaymentProducts];
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

- (void)filterAndroidPayFromProducts:(ICBasicPaymentProducts *)paymentProducts {
    ICBasicPaymentProduct *androidPayPaymentProduct = [paymentProducts paymentProductWithIdentifier:kICAndroidPayIdentifier];
    if (androidPayPaymentProduct != nil) {
        [paymentProducts.paymentProducts removeObject:androidPayPaymentProduct];
    }
}

- (void)checkApplePayAvailabilityWithPaymentProducts:(ICBasicPaymentProducts *)paymentProducts forContext:(ICPaymentContext *)context success:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    ICBasicPaymentProduct *applePayPaymentProduct = [paymentProducts paymentProductWithIdentifier:kICApplePayIdentifier];
    if (applePayPaymentProduct != nil) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") && [PKPaymentAuthorizationViewController canMakePayments]) {
            [self paymentProductNetworksForProductId:kICApplePayIdentifier context:context success:^(ICPaymentProductNetworks *paymentProductNetworks) {
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

- (void)paymentProductNetworksForProductId:(NSString *)paymentProductId context:(ICPaymentContext *)context success:(void (^)(ICPaymentProductNetworks *paymentProductNetworks))success failure:(void (^)(NSError *error))failure {
    NSString *isRecurring = context.isRecurring == YES ? @"true" : @"false";
    NSString *URL = [NSString stringWithFormat:@"%@/%@/products/%@/networks?countryCode=%@&locale=%@&currencyCode=%@&amount=%lu&hide=fields&isRecurring=%@", [self baseURL], self.configuration.customerId, paymentProductId, context.countryCode, context.locale, context.amountOfMoney.currencyCode, (unsigned long)context.amountOfMoney.totalAmount, isRecurring];
    [self getResponseForURL:URL success:^(id responseObject) {
        NSArray *rawProductNetworks = [(NSDictionary *)responseObject objectForKey:@"networks"];
        ICPaymentProductNetworks *paymentProductNetworks = [[ICPaymentProductNetworks alloc] init];
        [paymentProductNetworks.paymentProductNetworks addObjectsFromArray:rawProductNetworks];
        success(paymentProductNetworks);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)paymentProductGroupsForContext:(ICPaymentContext *)context success:(void (^)(ICBasicPaymentProductGroups *paymentProductGroups))success failure:(void (^)(NSError *error))failure {
    NSString *isRecurring = context.isRecurring == YES ? @"true" : @"false";
    NSString *URL = [NSString stringWithFormat:@"%@/%@/productgroups?countryCode=%@&locale=%@&currencyCode=%@&amount=%lu&hide=fields&isRecurring=%@", [self baseURL], self.configuration.customerId, context.countryCode, context.locale, context.amountOfMoney.currencyCode, (unsigned long)context.amountOfMoney.totalAmount, isRecurring];
    [self getResponseForURL:URL success:^(id responseObject) {
        NSArray *rawPaymentProductGroups = [(NSDictionary *)responseObject objectForKey:@"paymentProductGroups"];
        ICPaymentProductGroupsConverter *converter = [[ICPaymentProductGroupsConverter alloc] init];
        ICBasicPaymentProductGroups *paymentProductGroups = [converter paymentProductGroupsFromJSON:rawPaymentProductGroups];
        success(paymentProductGroups);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


- (void)paymentProductWithId:(NSString *)paymentProductId context:(ICPaymentContext *)context success:(void (^)(ICPaymentProduct *paymentProduct))success failure:(void (^)(NSError *error))failure
{
    [self checkAvailabilityForPaymentProductWithId:paymentProductId context:context success:^{
        NSString *isRecurring = context.isRecurring == YES ? @"true" : @"false";
        NSString *forceBasicFlow = context.forceBasicFlow == YES ? @"true" : @"false";
        NSString *URL = [NSString stringWithFormat:@"%@/%@/products/%@/?countryCode=%@&locale=%@&currencyCode=%@&amount=%lu&isRecurring=%@&forceBasicFlow=%@", [self baseURL], self.configuration.customerId, paymentProductId, context.countryCode, context.locale, context.amountOfMoney.currencyCode, (unsigned long)context.amountOfMoney.totalAmount, isRecurring, forceBasicFlow];
        [self getResponseForURL:URL success:^(id responseObject) {
            NSDictionary *rawPaymentProduct = (NSDictionary *)responseObject;
            ICPaymentProductConverter *converter = [[ICPaymentProductConverter alloc] init];
            ICPaymentProduct *paymentProduct = [converter paymentProductFromJSON:rawPaymentProduct];
            success(paymentProduct);
        } failure:^(NSError *error) {
            failure(error);
        }];
    } failure:^(NSError *error) {
        failure(error);
    }];
}
- (void)customerDetailsForProductId:(NSString *)productId withLookupValues:(NSArray<NSDictionary<NSString*, NSString*>*> *)values countryCode:(NSString *)countryCode success:(void (^)(ICCustomerDetails *))success failure:(void (^)(NSError *))failure
{
    NSString *URL = [NSString stringWithFormat:@"%@/%@/products/%@/customerDetails", [self baseURL], self.configuration.customerId, productId];
    NSDictionary<NSString *, id> *params = @{@"values": values, @"countryCode": countryCode};
    NSMutableIndexSet *additionalAcceptableStatusCodes = [[NSMutableIndexSet alloc] init];
//    [additionalAcceptableStatusCodes addIndex:400];
    [self postResponseForURL:URL withParameters:params additionalAcceptableStatusCodes:additionalAcceptableStatusCodes success:^(id responseObject) {
        NSDictionary *rawCustomerDetails = (NSDictionary *)responseObject;
        ICCustomerDetails *details = [[ICCustomerDetails alloc]init];
        details.values = rawCustomerDetails;
        success(details);
    } failure:^(NSError *error) {
        NSData *errorBody = (NSData *)error.userInfo[@"com.alamofire.serialization.response.error.data"];
        if (errorBody == nil) {
            failure(error);
            return;
        }
        NSMutableDictionary *dict =  [error.userInfo mutableCopy];
        NSMutableDictionary *object = [NSJSONSerialization JSONObjectWithData:errorBody options: 0 error:nil];
        dict[@"com.ingenicoconnect.responseBody"] = object;
        failure([NSError errorWithDomain:error.domain code:error.code userInfo:dict]);
    }];

}
- (void)checkAvailabilityForPaymentProductWithId:(NSString *)paymentProductId context:(ICPaymentContext *)context success:(void (^)(void))success failure:(void (^)(NSError *error))failure
{
    if ([paymentProductId isEqualToString:kICApplePayIdentifier]) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") && [PKPaymentAuthorizationViewController canMakePayments]) {
            [self paymentProductNetworksForProductId:kICApplePayIdentifier context:context success:^(ICPaymentProductNetworks *paymentProductNetworks) {
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

- (NSError *)badRequestErrorForPaymentProductId:(NSString *)paymentProductId context:(ICPaymentContext *)context {
    
    NSString *isRecurring = context.isRecurring == YES ? @"true" : @"false";
    NSString *URL = [NSString stringWithFormat:@"%@/%@/products/%@/?countryCode=%@&locale=%@&currencyCode=%@&amount=%lu&isRecurring=%@", [self baseURL], self.configuration.customerId, paymentProductId, context.countryCode, context.locale, context.amountOfMoney.currencyCode, (unsigned long)context.amountOfMoney.totalAmount, isRecurring];
    NSDictionary *errorUserInfo = @{@"com.alamofire.serialization.response.error.response": [[NSHTTPURLResponse alloc] initWithURL:[NSURL fileURLWithPath:URL] statusCode:400 HTTPVersion:nil headerFields:@{@"Connection": @"close"}],
                                    @"NSErrorFailingURLKey": URL,
                                    @"com.alamofire.serialization.response.error.data": [NSData data],
                                    @"NSLocalizedDescription": @"Request failed: bad request (400)"};
    NSError *error = [NSError errorWithDomain:@"com.alamofire.serialization.response.error.response" code:-1011 userInfo:errorUserInfo];
    return error;
}

- (void)paymentProductGroupWithId:(NSString *)paymentProductGroupId context:(ICPaymentContext *)context success:(void (^)(ICPaymentProductGroup *paymentProductGroup))success failure:(void (^)(NSError *error))failure {
    NSString *isRecurring = context.isRecurring == YES ? @"true" : @"false";
    NSString *URL = [NSString stringWithFormat:@"%@/%@/productgroups/%@/?countryCode=%@&locale=%@&currencyCode=%@&amount=%lu&isRecurring=%@", [self baseURL], self.configuration.customerId, paymentProductGroupId, context.countryCode, context.locale, context.amountOfMoney.currencyCode, (unsigned long)context.amountOfMoney.totalAmount, isRecurring];
    [self getResponseForURL:URL success:^(id responseObject) {
        NSDictionary *rawPaymentProductGroup = (NSDictionary *)responseObject;
        ICPaymentProductGroupConverter *converter = [[ICPaymentProductGroupConverter alloc] init];
        ICPaymentProductGroup *paymentProductGroup = [converter paymentProductGroupFromJSON:rawPaymentProductGroup];
        success(paymentProductGroup);
    } failure:^(NSError *error) {
        failure(error);
    }];

}

- (void)publicKey:(void (^)(ICPublicKeyResponse *publicKeyResponse))success failure:(void (^)(NSError *error))failure
{
    NSString *URL = [NSString stringWithFormat:@"%@/%@/crypto/publickey", [self baseURL], self.configuration.customerId];
    [self getResponseForURL:URL success:^(id responseObject) {
        NSDictionary *rawPublicKeyResponse = (NSDictionary *)responseObject;
        NSString *keyId = [rawPublicKeyResponse objectForKey:@"keyId"];
        NSString *encodedPublicKey = [rawPublicKeyResponse objectForKey:@"publicKey"];
        ICPublicKeyResponse *response = [[ICPublicKeyResponse alloc] initWithKeyId:keyId encodedPublicKey:encodedPublicKey];
        success(response);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
- (void)paymentProductIdByPartialCreditCardNumber:(NSString *)partialCreditCardNumber context:(ICPaymentContext *)context success:(void (^)(ICIINDetailsResponse *iinDetailsResponse))success failure:(void (^)(NSError *error))failure {
    NSString *URL = [NSString stringWithFormat:@"%@/%@/services/getIINdetails", [self baseURL], self.configuration.customerId];

    NSString *trimmedPartialCreditCardNumber = [self getIINDigitsFrom:partialCreditCardNumber];

    NSDictionary *parameters;
    ICPaymentContextConverter *converter = [[ICPaymentContextConverter alloc] init];
    if (context == nil) {
        parameters = [converter JSONFromPartialCreditCardNumber:trimmedPartialCreditCardNumber];
    }
    else {
        parameters = [converter JSONFromPaymentProductContext:context partialCreditCardNumber:trimmedPartialCreditCardNumber];
    }

    NSMutableIndexSet *additionalAcceptableStatusCodes = [[NSMutableIndexSet alloc] initWithIndex:404];

    [self postResponseForURL:URL withParameters:parameters additionalAcceptableStatusCodes:additionalAcceptableStatusCodes success:^(id responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        ICIINDetailsResponseConverter *converter = [[ICIINDetailsResponseConverter alloc] init];
        ICIINDetailsResponse *IINDetails = [converter IINDetailsResponseFromJSON:response];
        success(IINDetails);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (NSString *)getIINDigitsFrom:(NSString *)partialCreditCardNumber {
    int max;
    if (partialCreditCardNumber.length >= 8) {
     max = 8;
    }
    else {
     max = (int) MIN(partialCreditCardNumber.length, 6);
    }
    return [partialCreditCardNumber substringToIndex:max];
}

- (void)convertAmount:(long)amountInCents withSource:(NSString *)source target:(NSString *)target success:(void (^)(long convertedAmountInCents))success failure:(void (^)(NSError *error))failure
{
    NSString *amount = [NSString stringWithFormat:@"%ld", (long) amountInCents];
    NSString *URL = [NSString stringWithFormat:@"%@/%@/services/convert/amount?source=%@&target=%@&amount=%@", [self baseURL], self.configuration.customerId, source, target, amount];
    [self getResponseForURL:URL success:^(id responseObject) {
        NSDictionary *rawConvertResponse = (NSDictionary *)responseObject;
        NSString *convertedAmount = [rawConvertResponse objectForKey:@"convertedAmount"];
        long convertedAmountInCents = (long) [convertedAmount longLongValue];
        success(convertedAmountInCents);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)directoryForPaymentProductId:(NSString *)paymentProductId countryCode:(NSString *)countryCode currencyCode:(NSString *)currencyCode success:(void (^)(ICDirectoryEntries *directoryEntries))success failure:(void (^)(NSError *error))failure
{
    NSString *URL = [NSString stringWithFormat:@"%@/%@/products/%@/directory?countryCode=%@&currencyCode=%@", [self baseURL], self.configuration.customerId, paymentProductId, countryCode, currencyCode];
    [self getResponseForURL:URL success:^(id responseObject) {
        NSArray *rawDirectoryEntries = [(NSDictionary *)responseObject objectForKey:@"entries"];
        ICDirectoryEntriesConverter *converter = [[ICDirectoryEntriesConverter alloc] init];
        ICDirectoryEntries *directoryEntries = [converter directoryEntriesFromJSON:rawDirectoryEntries];
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

- (void)getResponseForURL:(NSString *)URL success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    if([self loggingEnabled]) {
        [self logRequestForURL:URL forRequestMethod:@"GET" withParameters:[NSDictionary alloc]];
    }

    [self.networkingWrapper
     getResponseForURL:URL
     headers:[self headers]
     additionalAcceptableStatusCodes:nil
     success:^(id responseObject) {
        if([self loggingEnabled]) {
            [self logSuccessResponseForURL:URL forResponseObject:responseObject];
        }

        success(responseObject);
     }
     failure:^(NSError *error) {
        if([self loggingEnabled]) {
            [self logResponseForURL:URL forResponseCode:[NSNumber numberWithInteger: error.code] forResponseBody:[error localizedDescription] hasError:YES];
        }
        failure(error);
     }
    ];
}

- (void)postResponseForURL:(NSString *)URL withParameters:(NSDictionary *)parameters additionalAcceptableStatusCodes:(NSIndexSet *)additionalAcceptableStatusCodes success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    if([self loggingEnabled]) {
        [self logRequestForURL:URL forRequestMethod:@"POST" withParameters:parameters];
    }
    [self.networkingWrapper
     postResponseForURL:URL
     headers:[self headers]
     withParameters:parameters
     additionalAcceptableStatusCodes:additionalAcceptableStatusCodes
     success:^(id responseObject) {
        if([self loggingEnabled]) {
            [self logSuccessResponseForURL:URL forResponseObject:responseObject];
        }

        success(responseObject);
     }
     failure:^(NSError *error) {
        if([self loggingEnabled]) {
            [self logResponseForURL:URL forResponseCode:[NSNumber numberWithInteger: error.code] forResponseBody:[error localizedDescription] hasError:YES];
        }
        failure(error);
     }
    ];
}

-(void)logSuccessResponseForURL:(NSString *)URL forResponseObject:(id)responseObject {
    NSNumber *responseCode = responseObject[@"statusCode"];

    [responseObject removeObjectForKey:@"statusCode"];

    [self logResponseForURL:URL forResponseCode:responseCode forResponseBody:responseObject hasError:NO];
}

/**
 * Logs all request headers, url and body
 */
-(void)logRequestForURL:(NSString *)URL forRequestMethod:(NSString *)requestMethod withParameters:(NSDictionary *)parameters {
    NSString* requestLog = [NSString stringWithFormat:
    @"Request URL : %@ \n"
    "Request Method: %@ \n"
    "Request Headers : %@ \n",
    URL, requestMethod, self.headers
    ];

    if([requestMethod isEqual: @"POST"]) {
        requestLog = [requestLog stringByAppendingString:[NSString stringWithFormat: @"Body: %@", parameters]];
    }

    NSLog(@"%@", requestLog);
}

/**
 * Logs all response headers, status code and body
 */
-(void)logResponseForURL:(NSString *)URL forResponseCode:(NSNumber *)responseCode forResponseBody:(NSString *)responseBody hasError:(BOOL)hasError {
    NSString* responseLog = [NSString stringWithFormat:
    @"Response URL : %@ \n"
    "Response Code : %@ \n"
    "Response Headers : %@ \n",
    URL, responseCode, self.headers];

    if(hasError) {
        responseLog = [responseLog stringByAppendingString:@"Response Error : "];
    } else {
        responseLog = [responseLog stringByAppendingString:@"Response Body : "];
    }

    responseLog = [responseLog stringByAppendingString:[NSString stringWithFormat: @"%@", responseBody]];

    NSLog(@"%@", responseLog);
}


- (NSString *)baseURL
{
    return [self.configuration baseURL];
}

-(void)setBaseURL:(NSString *)baseURL {
    [self.configuration setBaseURL:baseURL];
}

-(void)setAssetsBaseURL:(NSString *)assetsBaseURL {
    [self.configuration setAssetsBaseURL:assetsBaseURL];
}

- (NSString *)assetsBaseURL
{
    return [self.configuration assetsBaseURL];
}

-(void)setLoggingEnabled:(BOOL)loggingEnabled {
    [self.configuration setLoggingEnabled:loggingEnabled];
}

- (BOOL)loggingEnabled {
    return [self.configuration loggingEnabled];
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
