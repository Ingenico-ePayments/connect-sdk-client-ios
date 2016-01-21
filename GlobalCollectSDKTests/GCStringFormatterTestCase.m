//
//  GCStringFormatterTestCase.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 16/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCStringFormatter.h"

@interface GCStringFormatterTestCase : XCTestCase

@property (strong, nonatomic) GCStringFormatter *stringFormatter;

@end

@implementation GCStringFormatterTestCase

- (void)setUp
{
    [super setUp];
    self.stringFormatter = [[GCStringFormatter alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testFormatStringNumbers
{
    NSString *input = @"1234567890";
    NSString *mask = @"{{99}} {{99}} {{99}} {{99}} {{99}}";
    NSString *output = [self.stringFormatter formatString:input withMask:mask];
    NSString *expectedOutput = @"12 34 56 78 90";
    
    XCTAssertTrue([output isEqualToString:expectedOutput] == YES, @"Masking with numeric characters has failed");
}

- (void)testFormatStringWildcards
{
    NSString *input = @"!!!!!!!!!!";
    NSString *mask = @"{{**}} {{**}} {{**}} {{**}} {{**}}";
    NSString *output = [self.stringFormatter formatString:input withMask:mask];
    NSString *expectedOutput = @"!! !! !! !! !!";
    XCTAssertTrue([output isEqualToString:expectedOutput] == YES, @"Masking with wildcards has failed");
}

- (void)testFormatStringAlpha
{
    NSString *input = @"abcdefghij";
    NSString *mask = @"{{aa}} {{aa}} {{aa}} {{aa}} {{aa}}";
    NSString *output = [self.stringFormatter formatString:input withMask:mask];
    NSString *expectedOutput = @"ab cd ef gh ij";
    XCTAssertTrue([output isEqualToString:expectedOutput] == YES, @"Masking with alphabetic characters has failed");
}

- (void)testFormStringWithCursorPosition
{
    NSString *input = @"abcdefghij";
    NSInteger cursorPosition = 10;
    NSString *mask = @"{{aa}} {{aa}} {{aa}} {{aa}} {{aa}}";
    NSString *output = [self.stringFormatter formatString:input withMask:mask cursorPosition:&cursorPosition];
    NSString *expectedOutput = @"ab cd ef gh ij";
    XCTAssertTrue([output isEqualToString:expectedOutput] == YES && cursorPosition == 14, @"Masking with cursor position has failed");
}

- (void)testUnformString
{
    NSString *input = @"12 34 56 78 90";
    NSString *mask = @"{{99}} {{99}} {{99}} {{99}} {{99}}";
    NSString *output = [self.stringFormatter unformatString:input withMask:mask];
    NSString *expectedOutput = @"1234567890";
    XCTAssertTrue([output isEqualToString:expectedOutput] == YES, @"Unmasking a string has failed");
}

- (void)testRelaxMask
{
    NSString *input = @"{{9999}}/{{aaaa}}+{{****}}";
    NSString *output = [self.stringFormatter relaxMask:input];
    NSString *expectedOutput = @"{{****}}/{{****}}+{{****}}";
    XCTAssertTrue([output isEqualToString:expectedOutput] == YES, "Relaxing a mask has failed");
}

@end
