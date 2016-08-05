//
//  GCPaymentProductInputData.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 18/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GCPaymentItem;
@class GCAccountOnFile;
@class GCPaymentRequest;

@interface GCPaymentProductInputData : NSObject

@property (strong, nonatomic) NSObject<GCPaymentItem> *paymentItem;
@property (strong, nonatomic) GCAccountOnFile *accountOnFile;
@property (nonatomic) BOOL tokenize;
@property (strong, nonatomic) NSMutableArray *errors;

- (GCPaymentRequest *)paymentRequest;

- (BOOL)fieldIsPartOfAccountOnFile:(NSString *)paymentProductFieldId;
- (BOOL)fieldIsReadOnly:(NSString *)paymentProductFieldId;

- (void)setValue:(NSString *)value forField:(NSString *)paymentProductFieldId;
- (NSString *)maskedValueForField:(NSString *)paymentProductFieldId;
- (NSString *)maskedValueForField:(NSString *)paymentProductFieldId cursorPosition:(NSInteger *)cursorPosition;
- (NSString *)unmaskedValueForField:(NSString *)paymentProductFieldId;
- (void)validate;

@end
