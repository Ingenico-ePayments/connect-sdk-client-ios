//
//  GCPaymentRequest.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 02/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCPaymentProduct.h"
#import "GCPaymentRequest.h"

@interface GCPaymentRequest : NSObject

@property (strong, nonatomic) GCPaymentProduct *paymentProduct;
@property (strong, nonatomic) GCAccountOnFile *accountOnFile;
@property (strong, nonatomic) NSMutableArray *errors;
@property (nonatomic) BOOL tokenize;

- (void)setValue:(NSString *)value forField:(NSString *)paymentProductFieldId;
- (void)validate;
- (BOOL)fieldIsPartOfAccountOnFile:(NSString *)paymentProductFieldId;
- (BOOL)fieldIsReadOnly:(NSString *)paymentProductFieldId;
- (NSString *)maskedValueForField:(NSString *)paymentProductFieldId;
- (NSString *)maskedValueForField:(NSString *)paymentProductFieldId cursorPosition:(NSInteger *)cursorPosition;
- (NSString *)unmaskedValueForField:(NSString *)paymentProductFieldId;
- (NSDictionary *)unmaskedFieldValues;

@end
