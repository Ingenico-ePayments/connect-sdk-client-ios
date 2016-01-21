//
//  GCSession.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 02/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCMacros.h"
#import "GCSession.h"
#import "GCBase64.h"
#import "GCJSON.h"
#import "GCUtil.h"
#import "GCSDKConstants.h"

@interface GCSession ()

@property (strong, nonatomic) GCC2SCommunicator *communicator;
@property (strong, nonatomic) GCAssetManager *assetManager;
@property (strong, nonatomic) GCEncryptor *encryptor;
@property (strong, nonatomic) GCJOSEEncryptor *JOSEEncryptor;
@property (strong, nonatomic) GCStringFormatter *stringFormatter;
@property (strong, nonatomic) GCPaymentProducts *paymentProducts;
@property (strong, nonatomic) NSMutableDictionary *paymentProductMapping;
@property (strong, nonatomic) NSMutableDictionary *directoryEntriesMapping;
@property (strong, nonatomic) GCBase64 *base64;
@property (strong, nonatomic) GCJSON *JSON;
@property (strong, nonatomic) NSMutableDictionary *IINMapping;

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
    GCUtil *util = [[GCUtil alloc] init];
    GCAssetManager *assetManager = [[GCAssetManager alloc] init];
    GCStringFormatter *stringFormatter = [[GCStringFormatter alloc] init];
    GCEncryptor *encryptor = [[GCEncryptor alloc] init];
    GCC2SCommunicatorConfiguration *configuration = [[GCC2SCommunicatorConfiguration alloc] initWithClientSessionId:clientSessionId customerId:customerId region:region environment:environment util:util];
    GCC2SCommunicator *communicator = [[GCC2SCommunicator alloc] initWithConfiguration:configuration];
    GCJOSEEncryptor *JOSEEncryptor = [[GCJOSEEncryptor alloc] initWithEncryptor:encryptor];
    GCSession *session = [[GCSession alloc] initWithCommunicator:communicator assetManager:assetManager encryptor:encryptor JOSEEncryptor:JOSEEncryptor stringFormatter:stringFormatter];
    return session;
}

- (void)paymentProductsForContext:(GCC2SPaymentProductContext *)context success:(void (^)(GCPaymentProducts *paymentProducts))success failure:(void (^)(NSError *error))failure
{
    [self.communicator paymentProductsForContext:context success:^(GCPaymentProducts *paymentProducts) {
        self.paymentProducts = paymentProducts;
        self.paymentProducts.stringFormatter = self.stringFormatter;
        [self.assetManager initializeImagesForPaymentProducts:paymentProducts];
        [self.assetManager updateImagesForPaymentProductsAsynchronously:self.paymentProducts baseURL:[self.communicator assetsBaseURL]];
        success(paymentProducts);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)paymentProductWithId:(NSString *)paymentProductId context:(GCC2SPaymentProductContext *)context success:(void (^)(GCPaymentProduct *paymentProduct))success failure:(void (^)(NSError *error))failure
{
    NSString *key = [NSString stringWithFormat:@"%@-%@", paymentProductId, [context description]];
    GCPaymentProduct *paymentProduct = [self.paymentProductMapping objectForKey:key];
    if (paymentProduct != nil) {
        success(paymentProduct);
    } else {
        [self.communicator paymentProductWithId:paymentProductId context:context success:^(GCPaymentProduct *paymentProduct) {
            [self.paymentProductMapping setObject:paymentProduct forKey:key];
            [self.assetManager initializeImagesForPaymentProduct:paymentProduct];
            [self.assetManager updateImagesForPaymentProductAsynchronously:paymentProduct baseURL:[self.communicator assetsBaseURL]];
            success(paymentProduct);
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
}

- (GCIINDetailsResponse *)IINDetailsForPartialCreditCardNumber:(NSString *)partialCreditCardNumber;
{
    GCIINDetailsResponse *response;
    if (partialCreditCardNumber.length < 6) {
        response = [[GCIINDetailsResponse alloc] initWithPaymentProductId:@"" status:GCNotEnoughDigits];
    } else {
        NSString *truncatedCreditCardNumber = [partialCreditCardNumber substringToIndex:6];
        NSString *storedPaymentProductId = [self.IINMapping objectForKey:truncatedCreditCardNumber];
        if (storedPaymentProductId == nil) {
            storedPaymentProductId = @"#";
            [self.IINMapping setObject:storedPaymentProductId forKey:truncatedCreditCardNumber];
            [self.communicator paymentProductIdByPartialCreditCardNumber:partialCreditCardNumber success:^(NSString *paymentProductId) {
                [self.IINMapping setObject:paymentProductId forKey:truncatedCreditCardNumber];
                [StandardUserDefaults setObject:self.IINMapping forKey:kGCIINMapping];
                [StandardUserDefaults synchronize];
            } failure:^(NSError *error) {
            }];
        }
        response = [self IINDetailsForPaymentProductId:storedPaymentProductId];
    }
    return response;
}

- (GCIINDetailsResponse *)IINDetailsForPaymentProductId:(NSString *)paymentProductId
{
    GCIINDetailsResponse *response;
    if ([paymentProductId isEqualToString:@"#"] == YES) {
        response = [[GCIINDetailsResponse alloc] initWithPaymentProductId:@"" status:GCPending];
    } else if ([paymentProductId isEqualToString:@""] == YES) {
        response = [[GCIINDetailsResponse alloc] initWithPaymentProductId:@"" status:GCUnknown];
    } else {
        GCBasicPaymentProduct *basicPaymentProduct = [self.paymentProducts paymentProductWithIdentifier:paymentProductId];
        if (basicPaymentProduct == nil) {
            response = [[GCIINDetailsResponse alloc] initWithPaymentProductId:@"" status:GCUnsupported];
        } else {
            response = [[GCIINDetailsResponse alloc] initWithPaymentProductId:paymentProductId status:GCSupported];
        }
    }
    return response;
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

@end
