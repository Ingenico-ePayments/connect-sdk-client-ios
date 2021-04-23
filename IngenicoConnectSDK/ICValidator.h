//
//  ICValidator.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ICPaymentRequest;

@interface ICValidator : NSObject

@property (strong, nonatomic) NSMutableArray *errors;

- (void)validate:(NSString *)value DEPRECATED_ATTRIBUTE __deprecated_msg("Use validate:value:forPaymentRequest instead");
- (void)validate:(NSString *)value forPaymentRequest:(ICPaymentRequest *)request;

@end
