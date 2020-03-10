//
//  ICPaymentRequest.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import  "ICPaymentProduct.h"
#import  "ICPaymentRequest.h"

@interface ICPaymentRequest : NSObject

@property (strong, nonatomic) ICPaymentProduct *paymentProduct;
@property (strong, nonatomic) ICAccountOnFile *accountOnFile;
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
