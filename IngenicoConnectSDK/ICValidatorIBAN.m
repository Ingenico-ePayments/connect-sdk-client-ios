//
//  ICValidatorIBAN.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 01/03/2018.
//  Copyright © 2018 Global Collect Services. All rights reserved.
//

#import "ICValidatorIBAN.h"
#import "ICValidationErrorIBAN.h"
@implementation ICValidatorIBAN
- (NSString *)ibanRepresentationForCharacter:(NSString *)character {
    NSString *alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    if ([alphabet rangeOfString:character].location != NSNotFound) {
        NSString *replacementString = [NSString stringWithFormat:@"%ld", (long)([alphabet rangeOfString:character].location + 10)];
        return replacementString;
    }
    NSInteger val;
    if ([[NSScanner scannerWithString:character] scanInteger:&val]) {
        return [NSString stringWithFormat:@"%ld", (long)val];
    }
    return @"";
}
- (NSRange)rangeForString:(NSString *)s withRangeOfComposedCharacterSequences:(NSRange)range {
    NSUInteger currentCodeUnit = 0;
    NSRange result = NSMakeRange(0, 0);
    NSUInteger start = range.location;
    for (NSUInteger i = 0; i < start; i += 1)
    {
        result = [s rangeOfComposedCharacterSequenceAtIndex:currentCodeUnit];
        currentCodeUnit += result.length;
    }
    
    NSRange substringRange;
    substringRange.location = result.location + result.length;
    for (NSUInteger i = range.location; i < range.length; ++i)
    {
        result = [s rangeOfComposedCharacterSequenceAtIndex:currentCodeUnit];
        currentCodeUnit += result.length;
    }
    
    substringRange.length = result.location + result.length;
    return substringRange;
}
- (NSString *)substringForString:(NSString *)s withRangeOfComposedCharacterSequences:(NSRange)range
{
    NSRange substringRange = [self rangeForString:s withRangeOfComposedCharacterSequences:range];
    return [s substringWithRange:substringRange];
}
-(NSInteger)modulo:(NSInteger)mod forNumericString:(NSString *)str {
    NSMutableString *remainder = [str mutableCopy];
    do {
        NSString *currentChunk = [self substringForString:remainder withRangeOfComposedCharacterSequences:NSMakeRange(0, MIN(9, remainder.length))];
        NSInteger currentInt = [currentChunk integerValue];
        NSInteger currentResult = currentInt % mod;
        [remainder deleteCharactersInRange:[self rangeForString:remainder withRangeOfComposedCharacterSequences:NSMakeRange(0, MIN(9, remainder.length))]];
        [remainder insertString:[NSString stringWithFormat:@"%ld", (long) currentResult] atIndex:0];
    } while ([remainder length] > 2);
    NSInteger intval = [remainder integerValue];
    return intval;
}
-(void)validate:(NSString *)value forPaymentRequest:(ICPaymentRequest *)request {
    [super validate:value forPaymentRequest:request];
    NSString *strippedText = [[[value componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""] uppercaseString];
    NSRegularExpression *expr = [[NSRegularExpression alloc]initWithPattern:@"^[A-Z]{2}[0-9]{2}[A-Z0-9]{4}[0-9]{7}([A-Z0-9]?){0,16}$" options:0 error:NULL];
    NSInteger numberOfMatches = [expr numberOfMatchesInString:strippedText options:0 range:NSMakeRange(0, strippedText.length)];
    if (numberOfMatches == 1) {
        NSString *prefix = [self substringForString:strippedText withRangeOfComposedCharacterSequences:NSMakeRange(0, 4)];
        NSString *postfix = [self substringForString:strippedText withRangeOfComposedCharacterSequences:NSMakeRange(4, [strippedText length] - 4)];
        NSString *combinedString = [postfix stringByAppendingString:prefix];
        NSMutableString *numericString =  [NSMutableString stringWithCapacity:[combinedString length]];
        [combinedString enumerateSubstringsInRange:NSMakeRange(0, [combinedString length])
                                           options:NSStringEnumerationByComposedCharacterSequences
                                        usingBlock:
         ^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
             NSString *appendage = [self ibanRepresentationForCharacter:substring];
             [numericString appendString:appendage];
         }];
        NSInteger modulo = [self modulo:97 forNumericString:numericString];
        if (modulo == 1) {
            return;
        }
    }
    [self.errors addObject:[[ICValidationErrorIBAN alloc]init]];
}
@end
