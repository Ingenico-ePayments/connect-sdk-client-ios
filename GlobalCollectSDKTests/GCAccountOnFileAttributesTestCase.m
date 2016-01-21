//
//  GCAccountOnFileAttributesTestCase.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 16/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCAccountOnFileAttributes.h"
#import "GCAccountOnFileAttribute.h"

@interface GCAccountOnFileAttributesTestCase : XCTestCase

@property (strong, nonatomic) GCAccountOnFileAttributes *attributes;

@end

@implementation GCAccountOnFileAttributesTestCase

- (void)setUp
{
    [super setUp];
    self.attributes = [[GCAccountOnFileAttributes alloc] init];
    GCAccountOnFileAttribute *attribute1 = [[GCAccountOnFileAttribute alloc] init];
    attribute1.key = @"key1";
    attribute1.value = @"value1";
    GCAccountOnFileAttribute *attribute2 = [[GCAccountOnFileAttribute alloc] init];
    attribute2.key = @"key2";
    attribute2.value = @"value2";
    [self.attributes.attributes addObject:attribute1];
    [self.attributes.attributes addObject:attribute2];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testValueForField
{
    XCTAssertTrue([[self.attributes valueForField:@"key1"] isEqualToString:@"value1"] == YES, @"Incorrect value for key");
}

- (void)testHasValueForFieldYes
{
    XCTAssertTrue([self.attributes hasValueForField:@"key1"] == YES, @"Attributes should have a value for this key");
}

- (void)testHasValueForFieldNo
{
    XCTAssertTrue([self.attributes hasValueForField:@"key3"] == NO, @"Attributes should not have a value for this key");
}

@end
