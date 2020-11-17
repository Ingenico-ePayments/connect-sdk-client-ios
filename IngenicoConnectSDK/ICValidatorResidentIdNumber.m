//
//  ICValidatorResidentIdNumber.m
//  IngenicoConnectExample
//
//  Created for Ingenico ePayments on 8/10/2020.
//  Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "ICValidatorResidentIdNumber.h"
#import "ICResidentIdNumberError.h"

@interface ICValidatorResidentIdNumber ()

@end

@implementation ICValidatorResidentIdNumber

/**
 Validates a Chinese Resident ID Number.
    - Parameters:
        - Value: The ID to be verified, 15 to 18 characters long
        - PaymentRequest: The Payment request that the id is a part of
    - Important: The return value can be obtained by reading the errors array of this class
 */
- (void)validate:(NSString *)value forPaymentRequest:(ICPaymentRequest *)request
{
    [super validate:value forPaymentRequest:request];
    if (value.length == 15) {

        // We perform no checksum validation for IDs with a length of 15
        // These IDs are older and thus do not contain a checksum
        // We only check if the id is a valid Integer
        if (value.intValue == 0) {
            [self.errors addObject:[[ICResidentIdNumberError alloc] init]];
            return;
        }
    } else if (value.length == 18) {
        if (![self checkSumIsValid:value]) {
            [self.errors addObject:[[ICResidentIdNumberError alloc] init]];
            return;
        }
    } else {
        [self.errors addObject:[[ICResidentIdNumberError alloc] init]];
        return;
    }
}

/**
Validation according to ISO 7064 Standard, MOD 11-2
The polynomial method is used to calculate the checksum
- Parameters:
    - id: The id to be verified, a String consisting of 18 characters, which are all single digit Integers
 - Returns:
    - Bool: True if the checksum is valid
*/
- (bool)checkSumIsValid:(NSString *) id
{
    int mod = 11;
    NSInteger n = id.length - 1;

    int sum = 0;

    for (int i = 0; i < n; i ++) {
        /*
        First calculate the weight with the formula: 2^(n - 1)
        Where n is the index of the character starting from the end of the String
        This means the last number in the id has the n = 1, and the second to last has n = 2
         */

        int weight = (int)pow(2.0, n - i) % mod;

        /*
         We then calculate the product by multiplying the weight with the character value.
         We add this product to the sum and repeat this for every integer in the id,
         except the last digit because this is the checksum.
         */
        UniChar characterAtCurrent = [id characterAtIndex:i];
        int characterAtInt = [NSString stringWithCharacters: &characterAtCurrent length: 1].intValue;
        sum += weight * characterAtInt;
    }

    int checksum = (12 - (sum % mod)) % mod;

    UniChar characterAtEnd = [id characterAtIndex:n];
    int characterAtEndInt = (int)[NSString stringWithCharacters: &characterAtEnd length:1].intValue;

    if (checksum == 10) {
        NSString *characterAtEndString = [NSString stringWithCharacters: &characterAtEnd length: 1 ];
        if ([characterAtEndString isEqual: @"X"]) {
            return true;
        }
    } else if (characterAtEndInt == checksum) {
        return true;
    }

    return false;
}

@end
