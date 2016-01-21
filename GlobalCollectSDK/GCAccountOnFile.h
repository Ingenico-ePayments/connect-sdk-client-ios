//
//  GCAccountOnFile.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCAccountOnFileAttributes.h"
#import "GCAccountOnFileDisplayHints.h"
#import "GCStringFormatter.h"

@interface GCAccountOnFile : NSObject

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *paymentProductIdentifier;
@property (strong, nonatomic) GCAccountOnFileDisplayHints *displayHints;
@property (strong, nonatomic) GCAccountOnFileAttributes *attributes;

- (NSString *)maskedValueForField:(NSString *)paymentProductFieldId;
- (NSString *)maskedValueForField:(NSString *)paymentProductFieldId mask:(NSString *)mask;
- (BOOL)hasValueForField:(NSString *)paymentProductFieldId;
- (BOOL)fieldIsReadOnly:(NSString *)paymentProductFieldId;
- (NSString *)label;
- (void)setStringFormatter:(GCStringFormatter *)stringFormatter;

@end
