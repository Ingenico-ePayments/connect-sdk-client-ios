//
//  GCPaymentContextConverter.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 02/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import "GCPaymentContextConverter.h"
#import "GCPaymentContext.h"
#import "GCPaymentAmountOfMoney.h"

@implementation GCPaymentContextConverter {

}

- (NSDictionary *)JSONFromPartialCreditCardNumber:(NSString *)partialCreditCardNumber {
    NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
    json[@"bin"] = partialCreditCardNumber;
    return [NSDictionary dictionaryWithDictionary:json];
}

- (NSDictionary *)JSONFromPaymentProductContext:(GCPaymentContext *)paymentProductContext partialCreditCardNumber:(NSString *)partialCreditCardNumber {
    NSDictionary *partialCreditNumberJson = [self JSONFromPartialCreditCardNumber:partialCreditCardNumber];
    NSMutableDictionary *json= [NSMutableDictionary dictionaryWithDictionary:partialCreditNumberJson];
    json[@"paymentContext"] = [self JSONFromPaymentProductContext:paymentProductContext];
    return [NSDictionary dictionaryWithDictionary:json];
}


- (NSDictionary *)JSONFromPaymentProductContext:(GCPaymentContext *)paymentProductContext {
    NSMutableDictionary *rawPaymentProductContext = [[NSMutableDictionary alloc] init];
    NSString *isRecurring = paymentProductContext.isRecurring == YES ? @"true" : @"false";
    rawPaymentProductContext[@"isRecurring"] = isRecurring;
    rawPaymentProductContext[@"countryCode"] = paymentProductContext.countryCode;
    rawPaymentProductContext[@"amountOfMoney"] = [self JSONFromAmountOfMoney:paymentProductContext.amountOfMoney];
    return [NSDictionary dictionaryWithDictionary:rawPaymentProductContext];
}

-(NSDictionary *)JSONFromAmountOfMoney:(GCPaymentAmountOfMoney *)amountOfMoney {
    NSMutableDictionary *rawAmount = [[NSMutableDictionary alloc] init];
    rawAmount[@"amount"] = [NSString stringWithFormat:@"%lu", (unsigned long)amountOfMoney.totalAmount];
    rawAmount[@"currencyCode"] = amountOfMoney.currencyCode;
    return [NSDictionary dictionaryWithDictionary:rawAmount];
}

@end
