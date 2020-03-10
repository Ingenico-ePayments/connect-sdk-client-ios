//
//  ICBase64.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICBase64.h"

@implementation ICBase64

- (NSString *)URLEncode:(NSData *)data
{
    NSString *base64Encoded = [self encode:data];
    NSString *paddingStripped = [base64Encoded stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"="]];
    NSString *plusReplaced = [paddingStripped stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    NSString *slashReplaced = [plusReplaced stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return slashReplaced;
}

- (NSData *)URLDecode:(NSString *)string
{
    NSString *minusReplaced = [string stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
    NSString *underscoreReplaced = [minusReplaced stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    NSInteger modulo = underscoreReplaced.length % 4;
    NSMutableString *paddingAdded = [underscoreReplaced mutableCopy];
    if (modulo == 2) {
        [paddingAdded appendString:@"=="];
    } else if (modulo == 3) {
        [paddingAdded appendString:@"="];
    }
    NSData *base64Decoded = [self decode:paddingAdded];
    return base64Decoded;
}

// The following two methods use code provided as an answer to a question on StackOverflow:
// http://stackoverflow.com/questions/392464/how-do-i-do-base64-encoding-on-iphone-sdk/19794564#19794564.
// The answer was provided by Rob: http://stackoverflow.com/users/1271826/rob.
// The pragma commands to hide the deprecation warning are not part of the original code.
// These methods are included for backwards compatibility with versions of iOS older than iOS 7.

- (NSString *)encode:(NSData *)data
{
    NSString *string;
    
    if ([data respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        string = [data base64EncodedStringWithOptions:0];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        string = [data base64Encoding];
#pragma clang diagnostic pop
    }
    
    return string;
}

- (NSData *)decode:(NSString *)string
{
    NSData *data;
    
    if ([NSData instancesRespondToSelector:@selector(initWithBase64EncodedString:options:)]) {
        data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        data = [[NSData alloc] initWithBase64Encoding:string];
#pragma clang diagnostic pop
    }
    
    return data;
}

@end
