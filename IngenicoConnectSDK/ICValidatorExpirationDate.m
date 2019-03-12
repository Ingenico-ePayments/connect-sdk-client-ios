//
//  ICValidatorExpirationDate.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <IngenicoConnectSDK/ICValidatorExpirationDate.h>
#import <IngenicoConnectSDK/ICValidationErrorExpirationDate.h>

@interface ICValidatorExpirationDate ()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation ICValidatorExpirationDate

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"MMyy"];
    }
    return self;
}

- (void)validate:(NSString *)value forPaymentRequest:(ICPaymentRequest *)request
{
    [super validate:value forPaymentRequest:request];
    NSDate *submittedDate = [self.dateFormatter dateFromString:value];
    if (submittedDate == nil) {
        ICValidationErrorExpirationDate *error = [[ICValidationErrorExpirationDate alloc] init];
        [self.errors addObject:error];
    } else {
        // Add one month to the submitted date to make sure that the current month is also an allowed value
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setMonth:1];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *submittedDatePlusOneMonth = [calendar dateByAddingComponents:dateComponents toDate:submittedDate options:0];

        NSDate *today = [NSDate date];
        NSComparisonResult result = [today compare:submittedDatePlusOneMonth];
        if (result == NSOrderedDescending) {
            ICValidationErrorExpirationDate *error = [[ICValidationErrorExpirationDate alloc] init];
            [self.errors addObject:error];
        }
    }
}

@end
