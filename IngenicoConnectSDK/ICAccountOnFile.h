//
//  ICAccountOnFile.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import  "ICAccountOnFileAttributes.h"
#import  "ICAccountOnFileDisplayHints.h"
#import  "ICStringFormatter.h"

@interface ICAccountOnFile : NSObject

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *paymentProductIdentifier;
@property (strong, nonatomic) ICAccountOnFileDisplayHints *displayHints;
@property (strong, nonatomic) ICAccountOnFileAttributes *attributes;

- (NSString *)maskedValueForField:(NSString *)paymentProductFieldId;
- (NSString *)maskedValueForField:(NSString *)paymentProductFieldId mask:(NSString *)mask;
- (BOOL)hasValueForField:(NSString *)paymentProductFieldId;
- (BOOL)fieldIsReadOnly:(NSString *)paymentProductFieldId;
- (NSString *)label;
- (void)setStringFormatter:(ICStringFormatter *)stringFormatter;

@end
