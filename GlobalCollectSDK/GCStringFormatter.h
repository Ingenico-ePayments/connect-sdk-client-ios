//
//  GCStringFormatter.h
//  GlobalCollectSalesDemo
//
//  Created for Global Collect on 20/05/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCStringFormatter : NSObject

- (NSString *)formatString:(NSString *)string withMask:(NSString *)mask cursorPosition:(NSInteger *)cursorPosition;
- (NSString *)formatString:(NSString *)string withMask:(NSString *)mask;
- (NSString *)unformatString:(NSString *)string withMask:(NSString *)mask;
- (NSString *)relaxMask:(NSString *)mask;

@end
