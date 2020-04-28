//
//  ICUtil.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/sysctl.h>

#import  "ICUtil.h"
#import  "ICBase64.h"
#import  "ICMacros.h"

@interface ICUtil ()

@property (strong, nonatomic) NSDictionary *metaInfo;
@property (strong, nonatomic) ICBase64 *base64;
@property (strong, nonatomic) NSArray *c2sBaseURLMapping;
@property (strong, nonatomic) NSArray *assetsBaseURLMapping;

@end

@implementation ICUtil

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        NSString *platformIdentifier = [self platformIdentifier];
        NSString *screenSize = [self screenSize];
        NSString *deviceType = [self deviceType];
        self.metaInfo = @{
            @"platformIdentifier": platformIdentifier,
            @"sdkIdentifier": @"iOSClientSDK/v5.0.0",
            @"sdkCreator": @"Ingenico",
            @"screenSize": screenSize,
            @"deviceBrand": @"Apple",
            @"deviceType": deviceType};
        self.base64 = [[ICBase64 alloc] init];
    }
    return self;
}

- (NSString *)platformIdentifier
{
    NSString *OSName = [[UIDevice currentDevice] systemName];
    NSString *OSVersion = [[UIDevice currentDevice] systemVersion];
    NSString *platformIdentifier = [NSString stringWithFormat:@"%@/%@", OSName, OSVersion];
    return platformIdentifier;
}

- (NSString *)screenSize
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
    NSString *screenSizeAsString = [NSString stringWithFormat:@"%dx%d", (int)screenSize.width, (int)screenSize.height];
    return screenSizeAsString;
}

// The following method is based on code published by Scott Kantner on TechRepublic
// http://www.techrepublic.com/blog/software-engineer/better-code-determine-device-types-and-ios-versions/

- (NSString *)deviceType {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

- (NSString *)base64EncodedClientMetaInfo
{
    return [self base64EncodedClientMetaInfoWithAppIdentifier:nil];
}

- (NSString *)base64EncodedClientMetaInfoWithAddedData:(NSDictionary *)addedData
{
    return [self base64EncodedClientMetaInfoWithAppIdentifier:nil ipAddress:nil addedData:addedData];
}

- (NSString *)base64EncodedClientMetaInfoWithAppIdentifier:(NSString *)appIdentifier {
    return [self base64EncodedClientMetaInfoWithAppIdentifier:appIdentifier ipAddress:nil addedData:nil];
}

- (NSString *)base64EncodedClientMetaInfoWithAppIdentifier:(NSString *)appIdentifier ipAddress:(NSString *)ipAddress {
    return [self base64EncodedClientMetaInfoWithAppIdentifier:appIdentifier ipAddress:ipAddress addedData:nil];
}

- (NSString *)base64EncodedClientMetaInfoWithAppIdentifier:(NSString *)appIdentifier ipAddress:(NSString *)ipAddress addedData:(NSDictionary *)addedData {
    NSMutableDictionary *metaInfo = [self.metaInfo mutableCopy];
    if (addedData != nil) {
        [metaInfo addEntriesFromDictionary:addedData];
    }

    if (appIdentifier && appIdentifier.length > 0) {
        metaInfo[@"appIdentifier"] = appIdentifier;
    }
    else {
        metaInfo[@"appIdentifier"] = @"UNKNOWN";
    }

    if (ipAddress && ipAddress.length > 0) {
        metaInfo[@"ipAddress"] = ipAddress;
    }

    NSString *encodedMetaInfo = [self base64EncodedStringFromDictionary:metaInfo];
    return encodedMetaInfo;
}


- (NSString *)C2SBaseURLByRegion:(ICRegion)region environment:(ICEnvironment)environment
{
    switch (region) {
        case ICRegionEU:
            switch (environment) {
                case ICProduction:
                    return @"https://ams1.api-ingenico.com/client/v1";
                    break;
                case ICPreProduction:
                    return @"https://ams1.preprod.api-ingenico.com/client/v1";
                    break;
                case ICSandbox:
                    return @"https://ams1.sandbox.api-ingenico.com/client/v1";
                    break;
                default:
                    [NSException raise:@"Invalid environment" format:@"Environment %d is invalid", environment];
            }
        case ICRegionUS:
            switch (environment) {
                case ICProduction:
                    return @"https://us.api-ingenico.com/client/v1";
                    break;
                case ICPreProduction:
                    return @"https://us.preprod.api-ingenico.com/client/v1";
                    break;
                case ICSandbox:
                    return @"https://us.sandbox.api-ingenico.com/client/v1";
                    break;
                default:
                    [NSException raise:@"Invalid environment" format:@"Environment %d is invalid", environment];
                    break;
            }
        case ICRegionAMS:
            switch (environment) {
                case ICProduction:
                    return @"https://ams2.api-ingenico.com/client/v1";
                    break;
                case ICPreProduction:
                    return @"https://ams2.preprod.api-ingenico.com/client/v1";
                    break;
                case ICSandbox:
                    return @"https://ams2.sandbox.api-ingenico.com/client/v1";
                    break;
                default:
                    [NSException raise:@"Invalid environment" format:@"Environment %d is invalid", environment];
                    break;
            }
        case ICRegionPAR:
            switch (environment) {
                case ICProduction:
                    return @"https://par.api-ingenico.com/client/v1";
                    break;
                case ICPreProduction:
                    return @"https://par-preprod.api-ingenico.com/client/v1";
                    break;
                case ICSandbox:
                    return @"https://par.sandbox.api-ingenico.com/client/v1";
                    break;
                default:
                    [NSException raise:@"Invalid environment" format:@"Environment %d is invalid", environment];
                    break;
            }
        default:
            [NSException raise:@"Invalid region" format:@"Region %d is invalid", region];
            break;
    }
}

- (NSString *)assetsBaseURLByRegion:(ICRegion)region environment:(ICEnvironment)environment
{
    switch (region) {
        case ICRegionEU:
            switch (environment) {
                case ICProduction:
                    return @"https://assets.pay1.secured-by-ingenico.com";
                    break;
                case ICPreProduction:
                    return @"https://assets.pay1.preprod.secured-by-ingenico.com";
                    break;
                case ICSandbox:
                    return @"https://assets.pay1.sandbox.secured-by-ingenico.com";
                    break;
                default:
                    [NSException raise:@"Invalid environment" format:@"Environment %d is invalid", environment];
            }
        case ICRegionUS:
            switch (environment) {
                case ICProduction:
                    return @"https://assets.pay2.secured-by-ingenico.com";
                    break;
                case ICPreProduction:
                    return @"https://assets.pay2.preprod.secured-by-ingenico.com";
                    break;
                case ICSandbox:
                    return @"https://assets.pay2.sandbox.secured-by-ingenico.com";
                    break;
                default:
                    [NSException raise:@"Invalid environment" format:@"Environment %d is invalid", environment];
            }
        case ICRegionAMS:
            switch (environment) {
                case ICProduction:
                    return @"https://assets.pay3.secured-by-ingenico.com";
                    break;
                case ICPreProduction:
                    return @"https://assets.pay3.preprod.secured-by-ingenico.com";
                    break;
                case ICSandbox:
                    return @"https://assets.pay3.sandbox.secured-by-ingenico.com";
                    break;
                default:
                    [NSException raise:@"Invalid environment" format:@"Environment %d is invalid", environment];
            }
        case ICRegionPAR:
            switch (environment) {
                case ICProduction:
                    return @"https://assets.pay4.secured-by-ingenico.com";
                    break;
                case ICPreProduction:
                    return @"https://assets.pay4.preprod.secured-by-ingenico.com";
                    break;
                case ICSandbox:
                    return @"https://assets.pay4.sandbox.secured-by-ingenico.com";
                    break;
                default:
                    [NSException raise:@"Invalid environment" format:@"Environment %d is invalid", environment];
            }
        default:
            [NSException raise:@"Invalid region" format:@"Region %d is invalid", region];
            break;
    }
}

- (NSString *)base64EncodedStringFromDictionary:(NSDictionary *)dictionary
{
    NSError *error = nil;
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    if (error != nil) {
        DLog(@"Unable to serialize dictionary");
        return @"";
    }
    NSString *encodedString = [self.base64 encode:JSONData];
    return encodedString;
}

@end
