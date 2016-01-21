//
//  GCValidatorExpirationDate.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCValidatorExpirationDate.h"
#import "GCValidationErrorExpirationDate.h"

@interface GCValidatorExpirationDate ()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation GCValidatorExpirationDate

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"MMyy"];
    }
    return self;
}

- (void)validate:(NSString *)value
{
    [super validate:value];
    NSDate *submittedDate = [self.dateFormatter dateFromString:value];
    if (submittedDate == nil) {
        GCValidationErrorExpirationDate *error = [[GCValidationErrorExpirationDate alloc] init];
        [self.errors addObject:error];
    } else {
        NSDate *today = [NSDate date];
        NSComparisonResult result = [today compare:submittedDate];
        if (result == NSOrderedDescending) {
            GCValidationErrorExpirationDate *error = [[GCValidationErrorExpirationDate alloc] init];
            [self.errors addObject:error];
        }
    }
}

@end
