//
//  GCUtil.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 02/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <sys/sysctl.h>

#import "GCUtil.h"
#import "GCBase64.h"
#import "GCMacros.h"

@interface GCUtil ()

@property (strong, nonatomic) NSDictionary *metaInfo;
@property (strong, nonatomic) GCBase64 *base64;
@property (strong, nonatomic) NSArray *c2sBaseURLMapping;
@property (strong, nonatomic) NSArray *assetsBaseURLMapping;

@end

@implementation GCUtil

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        NSString *platformIdentifier = [self platformIdentifier];
        NSString *screenSize = [self screenSize];
        NSString *deviceType = [self deviceType];
        self.metaInfo = @{
            @"platformIdentifier": platformIdentifier,
            @"appIdentifier": @"Example iOS app/1.0",
            @"sdkIdentifier": @"iOSClientSDK/v2.0.0",
            @"sdkCreator": @"Ingenico",
            @"screenSize": screenSize,
            @"deviceBrand": @"Apple",
            @"deviceType": deviceType};
        self.base64 = [[GCBase64 alloc] init];
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
    NSString *encodedMetaInfo = [self base64EncodedStringFromDictionary:[self metaInfo]];
    return encodedMetaInfo;
}

- (NSString *)base64EncodedClientMetaInfoWithAddedData:(NSDictionary *)addedData
{
    NSMutableDictionary *metaInfo = [[self metaInfo] mutableCopy];
    [metaInfo addEntriesFromDictionary:addedData];
    NSString *encodedMetaInfo = [self base64EncodedStringFromDictionary:metaInfo];
    return encodedMetaInfo;
}

- (NSString *)C2SBaseURLByRegion:(GCRegion)region environment:(GCEnvironment)environment
{
    switch (region) {
        case GCRegionEU:
            switch (environment) {
                case GCProduction:
                    return @"https://api-eu.globalcollect.com/client/v1";
                    break;
                case GCPreProduction:
                    return @"https://api-eu-preprod.globalcollect.com/client/v1";
                    break;
                case GCSandbox:
                    return @"https://api-eu-sandbox.globalcollect.com/client/v1";
                    break;
                default:
                    [NSException raise:@"Invalid environment" format:@"Environment %d is invalid", environment];
            }
        case GCRegionUS:
            switch (environment) {
                case GCProduction:
                    return @"https://api-us.globalcollect.com/client/v1";
                    break;
                case GCPreProduction:
                    return @"https://api-us-preprod.globalcollect.com/client/v1";
                    break;
                case GCSandbox:
                    return @"https://api-us-sandbox.globalcollect.com/client/v1";
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

- (NSString *)assetsBaseURLByRegion:(GCRegion)region environment:(GCEnvironment)environment
{
    switch (region) {
        case GCRegionEU:
            switch (environment) {
                case GCProduction:
                    return @"https://assets.pay1.poweredbyglobalcollect.com";
                    break;
                case GCPreProduction:
                    return @"https://assets.pay1.preprod.poweredbyglobalcollect.com";
                    break;
                case GCSandbox:
                    return @"https://assets.pay1.sandbox.poweredbyglobalcollect.com";
                    break;
                default:
                    [NSException raise:@"Invalid environment" format:@"Environment %d is invalid", environment];
            }
        case GCRegionUS:
            switch (environment) {
                case GCProduction:
                    return @"https://assets.pay2.poweredbyglobalcollect.com";
                    break;
                case GCPreProduction:
                    return @"https://assets.pay2.preprod.poweredbyglobalcollect.com";
                    break;
                case GCSandbox:
                    return @"https://assets.pay2.sandbox.poweredbyglobalcollect.com";
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
