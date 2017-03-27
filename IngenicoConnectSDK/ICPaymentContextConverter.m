//
//  ICPaymentContextConverter.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <IngenicoConnectSDK/ICPaymentContextConverter.h>
#import <IngenicoConnectSDK/ICPaymentContext.h>
#import <IngenicoConnectSDK/ICPaymentAmountOfMoney.h>

@implementation ICPaymentContextConverter {

}

- (NSDictionary *)JSONFromPartialCreditCardNumber:(NSString *)partialCreditCardNumber {
    NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
    json[@"bin"] = partialCreditCardNumber;
    return [NSDictionary dictionaryWithDictionary:json];
}

- (NSDictionary *)JSONFromPaymentProductContext:(ICPaymentContext *)paymentProductContext partialCreditCardNumber:(NSString *)partialCreditCardNumber {
    NSDictionary *partialCreditNumberJson = [self JSONFromPartialCreditCardNumber:partialCreditCardNumber];
    NSMutableDictionary *json= [NSMutableDictionary dictionaryWithDictionary:partialCreditNumberJson];
    json[@"paymentContext"] = [self JSONFromPaymentProductContext:paymentProductContext];
    return [NSDictionary dictionaryWithDictionary:json];
}


- (NSDictionary *)JSONFromPaymentProductContext:(ICPaymentContext *)paymentProductContext {
    NSMutableDictionary *rawPaymentProductContext = [[NSMutableDictionary alloc] init];
    NSString *isRecurring = paymentProductContext.isRecurring == YES ? @"true" : @"false";
    rawPaymentProductContext[@"isRecurring"] = isRecurring;
    rawPaymentProductContext[@"countryCode"] = paymentProductContext.countryCode;
    rawPaymentProductContext[@"amountOfMoney"] = [self JSONFromAmountOfMoney:paymentProductContext.amountOfMoney];
    return [NSDictionary dictionaryWithDictionary:rawPaymentProductContext];
}

-(NSDictionary *)JSONFromAmountOfMoney:(ICPaymentAmountOfMoney *)amountOfMoney {
    NSMutableDictionary *rawAmount = [[NSMutableDictionary alloc] init];
    rawAmount[@"amount"] = [NSString stringWithFormat:@"%lu", (unsigned long)amountOfMoney.totalAmount];
    rawAmount[@"currencyCode"] = amountOfMoney.currencyCode;
    return [NSDictionary dictionaryWithDictionary:rawAmount];
}

@end
