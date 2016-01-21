//
//  GCLabelTemplateTestCase.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 16/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCLabelTemplate.h"
#import "GCLabelTemplateItem.h"

@interface GCLabelTemplateTestCase : XCTestCase

@property (strong, nonatomic) GCLabelTemplate *template;

@end

@implementation GCLabelTemplateTestCase

- (void)setUp
{
    [super setUp];
    self.template = [[GCLabelTemplate alloc] init];
    GCLabelTemplateItem *item1 = [[GCLabelTemplateItem alloc] init];
    item1.attributeKey = @"key1";
    item1.mask = @"mask1";
    GCLabelTemplateItem *item2 = [[GCLabelTemplateItem alloc] init];
    item2.attributeKey = @"key2";
    item2.mask = @"mask2";
    [self.template.labelTemplateItems addObject:item1];
    [self.template.labelTemplateItems addObject:item2];
    
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testMaskForAttributeKey
{
    NSString *mask = [self.template maskForAttributeKey:@"key1"];
    XCTAssertTrue([mask isEqualToString:@"mask1"] == YES, @"Unexpected mask encountered");
}

@end
