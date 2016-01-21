//
//  GCBase64.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 24/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCBase64 : NSObject

- (NSString *)encode:(NSData *)data;
- (NSData *)decode:(NSString *)string;
- (NSString *)URLEncode:(NSData *)data;
- (NSData *)URLDecode:(NSString *)string;

@end
