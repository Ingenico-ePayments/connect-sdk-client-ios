//
//  GCJSON.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 03/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCJSON.h"
#import "GCMacros.h"

@implementation GCJSON

- (NSString *)keyValueJSONFromDictionary:(NSDictionary *)dictionary
{
    NSArray *keyValuePairs = [self keyValuePairsFromDictionary:dictionary];
    NSError *error = nil;
    NSData *JSONAsData = [NSJSONSerialization dataWithJSONObject:keyValuePairs options:0 error:&error];
    
    NSString *JSON;
    if (error == nil) {
        JSON = [[NSString alloc] initWithData:JSONAsData encoding:NSUTF8StringEncoding];
    } else {
        DLog(@"Unable to create JSON data from dictionary.");
        JSON = @"";
    }
    return  JSON;
}

- (NSArray *)keyValuePairsFromDictionary:(NSDictionary *)dictionary
{
    NSMutableArray *keyValuePairs = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary) {
        NSString *value = [dictionary objectForKey:key];
        NSDictionary *pair = @{@"key": key, @"value": value};
        [keyValuePairs addObject:pair];
    }
    return keyValuePairs;
}

@end
