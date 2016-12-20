//
//  GCSession.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 02/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCSession.h"
#import "GCBase64.h"
#import "GCJSON.h"
#import "GCSDKConstants.h"
#import "GCBasicPaymentProductGroups.h"
#import "GCPaymentProductGroup.h"
#import "GCPaymentItems.h"
#import <PassKit/PassKit.h>

@interface GCSession ()

@property (strong, nonatomic) GCC2SCommunicator *communicator;
@property (strong, nonatomic) GCAssetManager *assetManager;
@property (strong, nonatomic) GCEncryptor *encryptor;
@property (strong, nonatomic) GCJOSEEncryptor *JOSEEncryptor;
@property (strong, nonatomic) GCStringFormatter *stringFormatter;
@property (strong, nonatomic) GCBasicPaymentProducts *paymentProducts;
@property (strong, nonatomic) GCBasicPaymentProductGroups *paymentProductGroups;
@property (strong, nonatomic) NSMutableDictionary *paymentProductMapping;
@property (strong, nonatomic) NSMutableDictionary *paymentProductGroupMapping;
@property (strong, nonatomic) NSMutableDictionary *directoryEntriesMapping;
@property (strong, nonatomic) GCBase64 *base64;
@property (strong, nonatomic) GCJSON *JSON;
@property (strong, nonatomic) NSMutableDictionary *IINMapping;
@property (assign, nonatomic) BOOL iinLookupPending;

@end

@implementation GCSession

- (instancetype)initWithCommunicator:(GCC2SCommunicator *)communicator assetManager:(GCAssetManager *)assetManager encryptor:(GCEncryptor *)encryptor JOSEEncryptor:(GCJOSEEncryptor *)JOSEEncryptor stringFormatter:(GCStringFormatter *)stringFormatter
{
    self = [super init];
    if (self != nil) {
        self.base64 = [[GCBase64 alloc] init];
        self.JSON = [[GCJSON alloc] init];
        self.communicator = communicator;
        self.assetManager = assetManager;
        self.encryptor = encryptor;
        self.JOSEEncryptor = JOSEEncryptor;
        self.stringFormatter = stringFormatter;
        self.IINMapping = [[StandardUserDefaults objectForKey:kGCIINMapping] mutableCopy];
        if (self.IINMapping == nil) {
            self.IINMapping = [[NSMutableDictionary alloc] init];
        }
        self.paymentProductMapping = [[NSMutableDictionary alloc] init];
        self.directoryEntriesMapping = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (GCSession *)sessionWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId region:(GCRegion)region environment:(GCEnvironment)environment
{
    return [self sessionWithClientSessionId:clientSessionId customerId:customerId region:region environment:environment appIdentifier:nil];
}

+ (GCSession *)sessionWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId region:(GCRegion)region environment:(GCEnvironment)environment appIdentifier:(NSString *)appIdentifier {
    GCUtil *util = [[GCUtil alloc] init];
    GCAssetManager *assetManager = [[GCAssetManager alloc] init];
    GCStringFormatter *stringFormatter = [[GCStringFormatter alloc] init];
    GCEncryptor *encryptor = [[GCEncryptor alloc] init];
    GCC2SCommunicatorConfiguration *configuration = [[GCC2SCommunicatorConfiguration alloc] initWithClientSessionId:clientSessionId customerId:customerId region:region environment:environment appIdentifier:appIdentifier util:util];
    GCC2SCommunicator *communicator = [[GCC2SCommunicator alloc] initWithConfiguration:configuration];
    GCJOSEEncryptor *JOSEEncryptor = [[GCJOSEEncryptor alloc] initWithEncryptor:encryptor];
    GCSession *session = [[GCSession alloc] initWithCommunicator:communicator assetManager:assetManager encryptor:encryptor JOSEEncryptor:JOSEEncryptor stringFormatter:stringFormatter];
    return session;
}


- (void)paymentProductsForContext:(GCPaymentContext *)context success:(void (^)(GCBasicPaymentProducts *paymentProducts))success failure:(void (^)(NSError *error))failure
{
    [self.communicator paymentProductsForContext:context success:^(GCBasicPaymentProducts *paymentProducts) {
        self.paymentProducts = paymentProducts;
        self.paymentProducts.stringFormatter = self.stringFormatter;
        [self.assetManager initializeImagesForPaymentItems:paymentProducts.paymentProducts];
        [self.assetManager updateImagesForPaymentItemsAsynchronously:paymentProducts.paymentProducts baseURL:[self.communicator assetsBaseURL]];
        success(paymentProducts);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)paymentProductNetworksForProductId:(NSString *)paymentProductId context:(GCPaymentContext *)context success:(void (^)(GCPaymentProductNetworks *paymentProductNetworks))success failure:(void (^)(NSError *error))failure {
    [self.communicator paymentProductNetworksForProductId:paymentProductId context:context success:^(GCPaymentProductNetworks *paymentProductNetworks) {
        success(paymentProductNetworks);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)paymentProductGroupsForContext:(GCPaymentContext *)context success:(void (^)(GCBasicPaymentProductGroups *paymentProductGroups))success failure:(void (^)(NSError *error))failure {
    [self.communicator paymentProductGroupsForContext:context success:^(GCBasicPaymentProductGroups *paymentProductGroups) {
        self.paymentProductGroups = paymentProductGroups;
        self.paymentProductGroups.stringFormatter = self.stringFormatter;
        [self.assetManager initializeImagesForPaymentItems:paymentProductGroups.paymentProductGroups];
        [self.assetManager updateImagesForPaymentItemsAsynchronously:paymentProductGroups.paymentProductGroups baseURL:[self.communicator assetsBaseURL]];
        success(paymentProductGroups);
    } failure:^(NSError *error) {
        failure(error);
    }];

}

- (void)paymentItemsForContext:(GCPaymentContext *)context groupPaymentProducts:(BOOL)groupPaymentProducts success:(void (^)(GCPaymentItems *paymentItems))success failure:(void (^)(NSError *error))failure {
    [self.communicator paymentProductsForContext:context success:^(GCBasicPaymentProducts *paymentProducts) {
        self.paymentProducts = paymentProducts;
        self.paymentProducts.stringFormatter = self.stringFormatter;
        [self.assetManager initializeImagesForPaymentItems:paymentProducts.paymentProducts];
        [self.assetManager updateImagesForPaymentItemsAsynchronously:paymentProducts.paymentProducts baseURL:[self.communicator assetsBaseURL]];

        if (groupPaymentProducts) {
            [self.communicator paymentProductGroupsForContext:context success:^(GCBasicPaymentProductGroups *paymentProductGroups) {
                self.paymentProductGroups = paymentProductGroups;
                self.paymentProductGroups.stringFormatter = self.stringFormatter;
                [self.assetManager initializeImagesForPaymentItems:paymentProductGroups.paymentProductGroups];
                [self.assetManager updateImagesForPaymentItemsAsynchronously:paymentProductGroups.paymentProductGroups baseURL:[self.communicator assetsBaseURL]];

                GCPaymentItems *items = [[GCPaymentItems alloc] initWithPaymentProducts:paymentProducts groups:paymentProductGroups];
                success(items);
            } failure:failure];
        }
        else {
            GCPaymentItems *items = [[GCPaymentItems alloc] initWithPaymentProducts:paymentProducts groups:nil];
            success(items);
        }
    } failure:failure];
}

- (void)paymentProductWithId:(NSString *)paymentProductId context:(GCPaymentContext *)context success:(void (^)(GCPaymentProduct *paymentProduct))success failure:(void (^)(NSError *error))failure
{
    NSString *key = [NSString stringWithFormat:@"%@-%@", paymentProductId, [context description]];
    GCPaymentProduct *paymentProduct = [self.paymentProductMapping objectForKey:key];
    if (paymentProduct != nil) {
        success(paymentProduct);
    } else {
        [self.communicator paymentProductWithId:paymentProductId context:context success:^(GCPaymentProduct *paymentProduct) {
            [self.paymentProductMapping setObject:paymentProduct forKey:key];
            [self.assetManager initializeImagesForPaymentItem:paymentProduct];
            [self.assetManager updateImagesForPaymentItemAsynchronously:paymentProduct baseURL:[self.communicator assetsBaseURL]];
            success(paymentProduct);
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
}

- (void)paymentProductGroupWithId:(NSString *)paymentProductGroupId context:(GCPaymentContext *)context success:(void (^)(GCPaymentProductGroup *paymentProductGroup))success failure:(void (^)(NSError *error))failure {
    NSString *key = [NSString stringWithFormat:@"%@-%@", paymentProductGroupId, [context description]];
    GCPaymentProductGroup *paymentProductGroup = [self.paymentProductGroupMapping objectForKey:key];
    if (paymentProductGroup != nil) {
        success(paymentProductGroup);
    } else {
        [self.communicator paymentProductGroupWithId:paymentProductGroupId context:context success:^(GCPaymentProductGroup *paymentProductGroup) {
            [self.paymentProductGroupMapping setObject:paymentProductGroup forKey:key];
            [self.assetManager initializeImagesForPaymentItem:paymentProductGroup];
            [self.assetManager updateImagesForPaymentItemAsynchronously:paymentProductGroup baseURL:[self.communicator assetsBaseURL]];
            success(paymentProductGroup);
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
}

- (void)IINDetailsForPartialCreditCardNumber:(NSString *)partialCreditCardNumber context:(GCPaymentContext *)context success:(void (^)(GCIINDetailsResponse *iinDetailsResponse))success failure:(void (^)(NSError *error))failure
{
    if (partialCreditCardNumber.length < 6) {
        GCIINDetailsResponse *response = [[GCIINDetailsResponse alloc] initWithStatus:GCNotEnoughDigits];
        success(response);
    } else if (self.iinLookupPending == YES) {
        GCIINDetailsResponse *response = [[GCIINDetailsResponse alloc] initWithStatus:GCPending];
        success(response);
    }
    else {
        self.iinLookupPending = YES;
        [self.communicator paymentProductIdByPartialCreditCardNumber:partialCreditCardNumber context:context success:^(GCIINDetailsResponse *response) {
            self.iinLookupPending = NO;
            success(response);
        } failure:^(NSError *error) {
            self.iinLookupPending = NO;
            failure(error);

        }];
    }
}

- (void)convertAmount:(long)amountInCents withSource:(NSString *)source target:(NSString *)target succes:(void (^)(long convertedAmountInCents))success failure:(void (^)(NSError *error))failure
{
    [self.communicator convertAmount:amountInCents withSource:source target:target succes:^(long convertedAmountInCents) {
        success(convertedAmountInCents);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)directoryForPaymentProductId:(NSString *)paymentProductId countryCode:(NSString *)countryCode currencyCode:(NSString *)currencyCode succes:(void (^)(GCDirectoryEntries *directory))success failure:(void (^)(NSError *error))failure
{
    NSString *key = [NSString stringWithFormat:@"%@-%@-%@", paymentProductId, countryCode, currencyCode];
    GCDirectoryEntries *directoryEntries = [self.directoryEntriesMapping objectForKey:key];
    if (directoryEntries != nil) {
        success(directoryEntries);
    } else {
        [self.communicator directoryForPaymentProductId:paymentProductId countryCode:countryCode currencyCode:currencyCode succes:^(GCDirectoryEntries *directoryEntries) {
            [self.directoryEntriesMapping setObject:directoryEntries forKey:key];
            success(directoryEntries);
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
}

- (void)preparePaymentRequest:(GCPaymentRequest *)paymentRequest success:(void (^)(GCPreparedPaymentRequest *preparedPaymentRequest))success failure:(void (^)(NSError *error))failure;
{
    [self.communicator publicKey:^(GCPublicKeyResponse *publicKeyResponse) {
        NSString *keyId = publicKeyResponse.keyId;
        
        NSString *encodedPublicKey = publicKeyResponse.encodedPublicKey;
        NSData *publicKeyAsData = [self.base64 decode:encodedPublicKey];
        NSData *strippedPublicKeyAsData = [self.encryptor stripPublicKey:publicKeyAsData];
        NSString *tag = @"globalcollect-sdk-public-key";
        [self.encryptor deleteRSAKeyWithTag:tag];
        [self.encryptor storePublicKey:strippedPublicKeyAsData tag:tag];
        SecKeyRef publicKey = [self.encryptor RSAKeyWithTag:tag];
        
        GCPreparedPaymentRequest *preparedRequest = [[GCPreparedPaymentRequest alloc] init];
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
