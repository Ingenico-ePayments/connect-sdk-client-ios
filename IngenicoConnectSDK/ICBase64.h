//
//  ICBase64.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICBase64 : NSObject

- (NSString *)encode:(NSData *)data;
- (NSData *)decode:(NSString *)string;
- (NSString *)URLEncode:(NSData *)data;
- (NSData *)URLDecode:(NSString *)string;

@end
