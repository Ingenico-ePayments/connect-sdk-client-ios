//
//  ICStringFormatter.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICStringFormatter : NSObject

- (NSString *)formatString:(NSString *)string withMask:(NSString *)mask cursorPosition:(NSInteger *)cursorPosition;
- (NSString *)formatString:(NSString *)string withMask:(NSString *)mask;
- (NSString *)unformatString:(NSString *)string withMask:(NSString *)mask;
- (NSString *)relaxMask:(NSString *)mask;

@end
