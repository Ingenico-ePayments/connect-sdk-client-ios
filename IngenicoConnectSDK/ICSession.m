//
//  ICSession.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICSession.h"
#import  "ICBase64.h"
#import  "ICJSON.h"
#import  "ICSDKConstants.h"
#import  "ICBasicPaymentProductGroups.h"
#import  "ICPaymentProductGroup.h"
#import  "ICPaymentItems.h"
#import <PassKit/PassKit.h>

@interface ICSession ()

@property (strong, nonatomic) ICC2SCommunicator *communicator;
@property (strong, nonatomic) ICAssetManager *assetManager;
@property (strong, nonatomic) ICEncryptor *encryptor;
@property (strong, nonatomic) ICJOSEEncryptor *JOSEEncryptor;
@property (strong, nonatomic) ICStringFormatter *stringFormatter;
@property (strong, nonatomic) ICBasicPaymentProducts *paymentProducts;
@property (strong, nonatomic) ICBasicPaymentProductGroups *paymentProductGroups;
@property (strong, nonatomic) NSMutableDictionary *paymentProductMapping;
@property (strong, nonatomic) NSMutableDictionary *paymentProductGroupMapping;
@property (strong, nonatomic) NSMutableDictionary *directoryEntriesMapping;
@property (strong, nonatomic) ICBase64 *base64;
@property (strong, nonatomic) ICJSON *JSON;
@property (strong, nonatomic) NSMutableDictionary *IINMapping;
@property (assign, nonatomic) BOOL iinLookupPending; 

@end

@implementation ICSession

- (instancetype)initWithCommunicator:(ICC2SCommunicator *)communicator assetManager:(ICAssetManager *)assetManager encryptor:(ICEncryptor *)encryptor JOSEEncryptor:(ICJOSEEncryptor *)JOSEEncryptor stringFormatter:(ICStringFormatter *)stringFormatter
{
    self = [super init];
    if (self != nil) {
        self.base64 = [[ICBase64 alloc] init];
        self.JSON = [[ICJSON alloc] init];
        self.communicator = communicator;
        self.assetManager = assetManager;
        self.encryptor = encryptor;
        self.JOSEEncryptor = JOSEEncryptor;
        self.stringFormatter = stringFormatter;
        self.IINMapping = [[StandardUserDefaults objectForKey:kICIINMapping] mutableCopy];
        if (self.IINMapping == nil) {
            self.IINMapping = [[NSMutableDictionary alloc] init];
        }
        self.paymentProductMapping = [[NSMutableDictionary alloc] init];
        self.directoryEntriesMapping = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(NSString *)baseURL {
    return [self.communicator baseURL];
}

-(NSString *)assetsBaseURL {
    return [self.communicator assetsBaseURL];
}
+ (ICSession *)sessionWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId baseURL:(NSString *)baseURL assetBaseURL:(NSString *)assetBaseURL appIdentifier:(NSString *)appIdentifier{
    ICUtil *util = [[ICUtil alloc] init];
    ICAssetManager *assetManager = [[ICAssetManager alloc] init];
    ICStringFormatter *stringFormatter = [[ICStringFormatter alloc] init];
    ICEncryptor *encryptor = [[ICEncryptor alloc] init];
    ICC2SCommunicatorConfiguration *configuration = [[ICC2SCommunicatorConfiguration alloc] initWithClientSessionId:clientSessionId customerId:customerId baseURL:baseURL assetBaseURL:assetBaseURL appIdentifier:appIdentifier util:util];
    ICC2SCommunicator *communicator = [[ICC2SCommunicator alloc] initWithConfiguration:configuration];
    ICJOSEEncryptor *JOSEEncryptor = [[ICJOSEEncryptor alloc] initWithEncryptor:encryptor];
    ICSession *session = [[ICSession alloc] initWithCommunicator:communicator assetManager:assetManager encryptor:encryptor JOSEEncryptor:JOSEEncryptor stringFormatter:stringFormatter];
    return session;
}
+ (ICSession *)sessionWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId region:(ICRegion)region environment:(ICEnvironment)environment
{
    return [self sessionWithClientSessionId:clientSessionId customerId:customerId region:region environment:environment appIdentifier:nil];
}

+ (ICSession *)sessionWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId region:(ICRegion)region environment:(ICEnvironment)environment appIdentifier:(NSString *)appIdentifier {
    ICUtil *util = [[ICUtil alloc] init];
    ICAssetManager *assetManager = [[ICAssetManager alloc] init];
    ICStringFormatter *stringFormatter = [[ICStringFormatter alloc] init];
    ICEncryptor *encryptor = [[ICEncryptor alloc] init];
    ICC2SCommunicatorConfiguration *configuration = [[ICC2SCommunicatorConfiguration alloc] initWithClientSessionId:clientSessionId customerId:customerId region:region environment:environment appIdentifier:appIdentifier util:util];
    ICC2SCommunicator *communicator = [[ICC2SCommunicator alloc] initWithConfiguration:configuration];
    ICJOSEEncryptor *JOSEEncryptor = [[ICJOSEEncryptor alloc] initWithEncryptor:encryptor];
    ICSession *session = [[ICSession alloc] initWithCommunicator:communicator assetManager:assetManager encryptor:encryptor JOSEEncryptor:JOSEEncryptor stringFormatter:stringFormatter];
    return session;
}


- (void)paymentProductsForContext:(ICPaymentContext *)context success:(void (^)(ICBasicPaymentProducts *paymentProducts))success failure:(void (^)(NSError *error))failure
{
    [self.communicator paymentProductsForContext:context success:^(ICBasicPaymentProducts *paymentProducts) {
        self.paymentProducts = paymentProducts;
        self.paymentProducts.stringFormatter = self.stringFormatter;
        [self.assetManager initializeImagesForPaymentItems:paymentProducts.paymentProducts];
        [self.assetManager updateImagesForPaymentItemsAsynchronously:paymentProducts.paymentProducts baseURL:[self.communicator assetsBaseURL] callback:^{
            [self.assetManager initializeImagesForPaymentItems:paymentProducts.paymentProducts];
            success(paymentProducts);
        }];
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)paymentProductNetworksForProductId:(NSString *)paymentProductId context:(ICPaymentContext *)context success:(void (^)(ICPaymentProductNetworks *paymentProductNetworks))success failure:(void (^)(NSError *error))failure {
    [self.communicator paymentProductNetworksForProductId:paymentProductId context:context success:^(ICPaymentProductNetworks *paymentProductNetworks) {
        success(paymentProductNetworks);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)paymentProductGroupsForContext:(ICPaymentContext *)context success:(void (^)(ICBasicPaymentProductGroups *paymentProductGroups))success failure:(void (^)(NSError *error))failure {
    [self.communicator paymentProductGroupsForContext:context success:^(ICBasicPaymentProductGroups *paymentProductGroups) {
        self.paymentProductGroups = paymentProductGroups;
        self.paymentProductGroups.stringFormatter = self.stringFormatter;
        [self.assetManager initializeImagesForPaymentItems:paymentProductGroups.paymentProductGroups];
        [self.assetManager updateImagesForPaymentItemsAsynchronously:paymentProductGroups.paymentProductGroups baseURL:[self.communicator assetsBaseURL] callback:^{
            [self.assetManager initializeImagesForPaymentItems:paymentProductGroups.paymentProductGroups];
            success(paymentProductGroups);
        }];
    } failure:^(NSError *error) {
        failure(error);
    }];

}
- (void)thirdPartyStatusForPayment:(NSString *)paymentId success:(void(^)(ICThirdPartyStatusResponse *thirdPartyStatusResponse))success failure:(void(^)(NSError *error))failure
{
    [self.communicator thirdPartyStatusForPayment:paymentId success:success failure:failure];
}
- (void)customerDetailsForProductId:(NSString *)productId withLookupValues:(NSArray<NSDictionary<NSString*, NSString*>*> *)values countryCode:(NSString *)countryCode success:(void (^)(ICCustomerDetails *))success failure:(void (^)(NSError *))failure
{
    [self.communicator customerDetailsForProductId:productId withLookupValues:values countryCode:countryCode success:success failure:failure];
}
- (void)paymentItemsForContext:(ICPaymentContext *)context groupPaymentProducts:(BOOL)groupPaymentProducts success:(void (^)(ICPaymentItems *paymentItems))success failure:(void (^)(NSError *error))failure {
    [self.communicator paymentProductsForContext:context success:^(ICBasicPaymentProducts *paymentProducts) {
        self.paymentProducts = paymentProducts;
        self.paymentProducts.stringFormatter = self.stringFormatter;
        [self.assetManager initializeImagesForPaymentItems:paymentProducts.paymentProducts];
        [self.assetManager updateImagesForPaymentItemsAsynchronously:paymentProducts.paymentProducts baseURL:[self.communicator assetsBaseURL] callback:^{
            [self.assetManager initializeImagesForPaymentItems:paymentProducts.paymentProducts];
            if (groupPaymentProducts) {
                [self.communicator paymentProductGroupsForContext:context success:^(ICBasicPaymentProductGroups *paymentProductGroups) {
                    self.paymentProductGroups = paymentProductGroups;
                    self.paymentProductGroups.stringFormatter = self.stringFormatter;
                    [self.assetManager initializeImagesForPaymentItems:paymentProductGroups.paymentProductGroups];
                    [self.assetManager updateImagesForPaymentItemsAsynchronously:paymentProductGroups.paymentProductGroups baseURL:[self.communicator assetsBaseURL] callback:^{
                        [self.assetManager initializeImagesForPaymentItems:paymentProductGroups.paymentProductGroups];
                        ICPaymentItems *items = [[ICPaymentItems alloc] initWithPaymentProducts:paymentProducts groups:paymentProductGroups];
                        success(items);
                    }];
                    
                } failure:failure];
            }
            else {
                ICPaymentItems *items = [[ICPaymentItems alloc] initWithPaymentProducts:paymentProducts groups:nil];
                success(items);
            }
        }];

    } failure:failure];
}

- (void)paymentProductWithId:(NSString *)paymentProductId context:(ICPaymentContext *)context success:(void (^)(ICPaymentProduct *paymentProduct))success failure:(void (^)(NSError *error))failure
{
    NSString *key = [NSString stringWithFormat:@"%@-%@", paymentProductId, [context description]];
    ICPaymentProduct *paymentProduct = [self.paymentProductMapping objectForKey:key];
    if (paymentProduct != nil) {
        success(paymentProduct);
    } else {
        [self.communicator paymentProductWithId:paymentProductId context:context success:^(ICPaymentProduct *paymentProduct) {
            [self.paymentProductMapping setObject:paymentProduct forKey:key];
            [self.assetManager initializeImagesForPaymentItem:paymentProduct];
            [self.assetManager updateImagesForPaymentItemAsynchronously:paymentProduct baseURL:[self.communicator assetsBaseURL] callback:^{
                [self.assetManager initializeImagesForPaymentItem:paymentProduct];
                success(paymentProduct);
            }];
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
}

- (void)paymentProductGroupWithId:(NSString *)paymentProductGroupId context:(ICPaymentContext *)context success:(void (^)(ICPaymentProductGroup *paymentProductGroup))success failure:(void (^)(NSError *error))failure {
    NSString *key = [NSString stringWithFormat:@"%@-%@", paymentProductGroupId, [context description]];
    ICPaymentProductGroup *paymentProductGroup = [self.paymentProductGroupMapping objectForKey:key];
    if (paymentProductGroup != nil) {
        success(paymentProductGroup);
    } else {
        [self.communicator paymentProductGroupWithId:paymentProductGroupId context:context success:^(ICPaymentProductGroup *paymentProductGroup) {
            [self.paymentProductGroupMapping setObject:paymentProductGroup forKey:key];
            [self.assetManager initializeImagesForPaymentItem:paymentProductGroup];
            [self.assetManager updateImagesForPaymentItemAsynchronously:paymentProductGroup baseURL:[self.communicator assetsBaseURL] callback:^{
                [self.assetManager initializeImagesForPaymentItem:paymentProductGroup];
                success(paymentProductGroup);
            }];
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
}

- (void)IINDetailsForPartialCreditCardNumber:(NSString *)partialCreditCardNumber context:(ICPaymentContext *)context success:(void (^)(ICIINDetailsResponse *iinDetailsResponse))success failure:(void (^)(NSError *error))failure
{
    if (partialCreditCardNumber.length < 6) {
        ICIINDetailsResponse *response = [[ICIINDetailsResponse alloc] initWithStatus:ICNotEnoughDigits];
        success(response);
    } else if (self.iinLookupPending == YES) {
        ICIINDetailsResponse *response = [[ICIINDetailsResponse alloc] initWithStatus:ICPending];
        success(response);
    }
    else {
        self.iinLookupPending = YES;
        [self.communicator paymentProductIdByPartialCreditCardNumber:partialCreditCardNumber context:context success:^(ICIINDetailsResponse *response) {
            self.iinLookupPending = NO;
            success(response);
        } failure:^(NSError *error) {
            self.iinLookupPending = NO;
            failure(error);

        }];
    }
}

- (void)convertAmount:(long)amountInCents withSource:(NSString *)source target:(NSString *)target success:(void (^)(long convertedAmountInCents))success failure:(void (^)(NSError *error))failure
{
    [self.communicator convertAmount:amountInCents withSource:source target:target success:^(long convertedAmountInCents) {
        success(convertedAmountInCents);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)directoryForPaymentProductId:(NSString *)paymentProductId countryCode:(NSString *)countryCode currencyCode:(NSString *)currencyCode success:(void (^)(ICDirectoryEntries *directory))success failure:(void (^)(NSError *error))failure
{
    NSString *key = [NSString stringWithFormat:@"%@-%@-%@", paymentProductId, countryCode, currencyCode];
    ICDirectoryEntries *directoryEntries = [self.directoryEntriesMapping objectForKey:key];
    if (directoryEntries != nil) {
        success(directoryEntries);
    } else {
        [self.communicator directoryForPaymentProductId:paymentProductId countryCode:countryCode currencyCode:currencyCode success:^(ICDirectoryEntries *directoryEntries) {
            [self.directoryEntriesMapping setObject:directoryEntries forKey:key];
            success(directoryEntries);
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
}

- (void)preparePaymentRequest:(ICPaymentRequest *)paymentRequest success:(void (^)(ICPreparedPaymentRequest *preparedPaymentRequest))success failure:(void (^)(NSError *error))failure;
{
    [self.communicator publicKey:^(ICPublicKeyResponse *publicKeyResponse) {
        NSString *keyId = publicKeyResponse.keyId;
        
        NSString *encodedPublicKey = publicKeyResponse.encodedPublicKey;
        NSData *publicKeyAsData = [self.base64 decode:encodedPublicKey];
        NSData *strippedPublicKeyAsData = [self.encryptor stripPublicKey:publicKeyAsData];
        NSString *tag = @"globalcollect-sdk-public-key";
        [self.encryptor deleteRSAKeyWithTag:tag];
        [self.encryptor storePublicKey:strippedPublicKeyAsData tag:tag];
        SecKeyRef publicKey = [self.encryptor RSAKeyWithTag:tag];
        
        ICPreparedPaymentRequest *preparedRequest = [[ICPreparedPaymentRequest alloc] init];
        NSMutableString *paymentRequestJSON = [[NSMutableString alloc] init];
        NSString *clientSessionId = [NSString stringWithFormat:@"{\"clientSessionId\": \"%@\", ", [self clientSessionId]];
        [paymentRequestJSON appendString:clientSessionId];
        NSString *nonce = [NSString stringWithFormat:@"\"nonce\": \"%@\", ", [self.encryptor UUID]];
        [paymentRequestJSON appendString:nonce];
        NSString *paymentProduct = [NSString stringWithFormat:@"\"paymentProductId\": %ld, ", (long)[paymentRequest.paymentProduct.identifier integerValue]];
        [paymentRequestJSON appendString:paymentProduct];
        if (paymentRequest.accountOnFile != nil) {
            NSString *accountOnFile = [NSString stringWithFormat:@"\"accountOnFileId\": %ld, ", (long)[paymentRequest.accountOnFile.identifier integerValue]];
            [paymentRequestJSON appendString:accountOnFile];
        }
        if (paymentRequest.tokenize == YES) {
            NSString *tokenize = @"\"tokenize\": true, ";
            [paymentRequestJSON appendString:tokenize];
        }
        NSString *paymentValues = [NSString stringWithFormat:@"\"paymentValues\": %@}", [self.JSON keyValueJSONFromDictionary:paymentRequest.unmaskedFieldValues]];
        [paymentRequestJSON appendString:paymentValues];
        preparedRequest.encryptedFields = [self.JOSEEncryptor encryptToCompactSerialization:paymentRequestJSON withPublicKey:publicKey keyId:keyId];
        preparedRequest.encodedClientMetaInfo = [self.communicator base64EncodedClientMetaInfo];
        success(preparedRequest);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (NSString *)clientSessionId
{
    return [self.communicator clientSessionId];
}

- (BOOL)isEnvironmentTypeProduction {
    return [self.communicator isEnvironmentTypeProduction];
}

@end
