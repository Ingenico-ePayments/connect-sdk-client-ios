//
//  ICAccountOnFileAttributesTestCase.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <IngenicoConnectSDK/ICAccountOnFileAttributes.h>
#import <IngenicoConnectSDK/ICAccountOnFileAttribute.h>

@interface ICAccountOnFileAttributesTestCase : XCTestCase

@property (strong, nonatomic) ICAccountOnFileAttributes *attributes;

@end

@implementation ICAccountOnFileAttributesTestCase

- (void)setUp
{
    [super setUp];
    self.attributes = [[ICAccountOnFileAttributes alloc] init];
    ICAccountOnFileAttribute *attribute1 = [[ICAccountOnFileAttribute alloc] init];
    attribute1.key = @"key1";
    attribute1.value = @"value1";
    ICAccountOnFileAttribute *attribute2 = [[ICAccountOnFileAttribute alloc] init];
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
