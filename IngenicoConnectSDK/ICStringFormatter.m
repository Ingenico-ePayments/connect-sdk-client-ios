//
//  ICStringFormatter.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICStringFormatter.h"

@interface ICStringFormatter()

@property (strong, nonatomic) NSRegularExpression *decimalRegex;
@property (strong, nonatomic) NSRegularExpression *lowerAlphaRegex;
@property (strong, nonatomic) NSRegularExpression *upperAlphaRegex;

@end

@implementation ICStringFormatter

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.decimalRegex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:0 error:NULL];
        self.lowerAlphaRegex = [NSRegularExpression regularExpressionWithPattern:@"[a-z]" options:0 error:NULL];
        self.upperAlphaRegex = [NSRegularExpression regularExpressionWithPattern:@"[A-Z]" options:0 error:NULL];
    }
    return self;
}

- (NSString *)formatString:(NSString *)string withMask:(NSString *)mask
{
    NSInteger cursorPosition = 0;
    return [self formatString:string withMask:mask cursorPosition:&cursorPosition];
}

- (NSString *)formatString:(NSString *)string withMask:(NSString *)mask cursorPosition:(NSInteger *)cursorPosition
{
    NSArray *matches = [self splitMask:mask];
    BOOL copyFromMask = YES;
    BOOL appendRestOfMask = YES;
    NSInteger stringIndex = 0;
    NSMutableString *result = [@"" mutableCopy];
    for (NSTextCheckingResult *match in matches) {
        NSString *matchString = [self processMatch:match string:string stringIndex:&stringIndex mask:mask copyFromMask:&copyFromMask appendRestOfMask:&appendRestOfMask cursorPosition:cursorPosition];
        [result appendString:matchString];
    }
    return result;
}

- (NSString *)unformatString:(NSString *)string withMask:(NSString *)mask
{
    NSString *maskedString = [self formatString:string withMask:mask];
    NSArray *matches = [self splitMask:mask];
    NSMutableString *result = [@"" mutableCopy];
    BOOL skip = YES;
    int index = 0;
    for (NSTextCheckingResult *match in matches) {
        NSString *maskFragment = [mask substringWithRange:match.range];
        if ([maskFragment isEqualToString:@"{{"] == YES) {
            skip = NO;
        } else if ([maskFragment isEqualToString:@"}}"] == YES) {
            skip = YES;
        } else {
            NSInteger maxLength = maskedString.length - index;
            NSInteger length = MIN(maxLength, match.range.length);
            if (skip == NO) {
                NSString *maskedStringFragment = [maskedString substringWithRange:NSMakeRange(index, length)];
                [result appendString:maskedStringFragment];
            }
            index += length;
        }
    }
    return result;
}

- (NSString *)processMatch:(NSTextCheckingResult *)match string:(NSString *)string stringIndex:(NSInteger *)stringIndex mask:(NSString *)mask copyFromMask:(BOOL *)copyFromMask appendRestOfMask:(BOOL *)appendRestOfMask cursorPosition:(NSInteger *)cursorPosition
{
    NSMutableString *result = [@"" mutableCopy];
    NSString *maskFragment = [mask substringWithRange:match.range];
    if ([maskFragment isEqualToString:@"{{"] == YES) {
        *copyFromMask = NO;
    } else if ([maskFragment isEqualToString:@"}}"] == YES) {
        *copyFromMask = YES;
    } else {
        NSInteger maskIndex = 0;
        while (*stringIndex < string.length && maskIndex < match.range.length) {
            NSString *stringChar = [string substringWithRange:NSMakeRange(*stringIndex, 1)];
            NSString *maskChar = [maskFragment substringWithRange:NSMakeRange(maskIndex, 1)];
            if (*copyFromMask == YES) {
                [result appendString:maskChar];
                if ([stringChar isEqualToString:maskChar] == YES) {
                    ++*stringIndex;
                } else {
                    if (*cursorPosition >= *stringIndex) {
                        ++*cursorPosition;
                    }
                }
                ++maskIndex;
            } else {
                NSRange range = NSMakeRange(0, 1);
                if ([maskChar isEqualToString:@"9"] == YES && [self.decimalRegex numberOfMatchesInString:stringChar options:0 range:range] > 0) {
                    [result appendString:stringChar];
                    ++maskIndex;
                } else if ([maskChar isEqualToString:@"a"] == YES && [self.lowerAlphaRegex numberOfMatchesInString:stringChar options:0 range:range] > 0) {
                    [result appendString:stringChar];
                    ++maskIndex;
                } else if ([maskChar isEqualToString:@"A"] == YES && [self.upperAlphaRegex numberOfMatchesInString:stringChar options:0 range:range] > 0) {
                    [result appendString:stringChar];
                    ++maskIndex;
                } else if ([maskChar isEqualToString:@"*"] == YES) {
                    [result appendString:stringChar];
                    ++maskIndex;
                }
                ++*stringIndex;
            }
        }
        if (*appendRestOfMask == YES) {
            if (maskIndex < match.range.length) {
                if (*copyFromMask == YES) {
                    NSInteger remainingLength = match.range.length - maskIndex;
                    [result appendString:[maskFragment substringWithRange:NSMakeRange(maskIndex, remainingLength)]];
                    if (*cursorPosition >= *stringIndex) {
                        *cursorPosition += remainingLength;
                    }
                }
                *appendRestOfMask = NO;
            }
        }
    }
    return result;
}

- (NSArray *)splitMask:(NSString *)mask
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\{\\{|\\}\\}|([^\\{\\}]|\\{(?!\\{)|\\}(?!\\}))*" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:mask options:0 range:NSMakeRange(0, mask.length)];
    return matches;
}

- (NSString *)relaxMask:(NSString *)mask
{
    NSArray *matches = [self splitMask:mask];
    NSMutableString *relaxedMask = [mask mutableCopy];
    BOOL replaceCharacters = NO;
    int maskIndex = 0;
    for (NSTextCheckingResult *match in matches) {
        NSString *maskFragment = [mask substringWithRange:match.range];
        if ([maskFragment isEqualToString:@"{{"] == YES) {
            replaceCharacters = YES;
            maskIndex = maskIndex + 2;
        } else if ([maskFragment isEqualToString:@"}}"] == YES) {
            replaceCharacters = NO;
            maskIndex = maskIndex + 2;
        } else {
            for (int i = 0; i < maskFragment.length; ++i) {
                if (replaceCharacters == YES) {
                    [relaxedMask replaceCharactersInRange:NSMakeRange(maskIndex, 1) withString:@"*"];
                }
                ++maskIndex;
            }
        }
    }
    return relaxedMask;
}

@end
