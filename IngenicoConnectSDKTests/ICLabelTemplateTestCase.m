//
//  ICLabelTemplateTestCase.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>
#import  "ICLabelTemplate.h"
#import  "ICLabelTemplateItem.h"

@interface ICLabelTemplateTestCase : XCTestCase

@property (strong, nonatomic) ICLabelTemplate *template;

@end

@implementation ICLabelTemplateTestCase

- (void)setUp
{
    [super setUp];
    self.template = [[ICLabelTemplate alloc] init];
    ICLabelTemplateItem *item1 = [[ICLabelTemplateItem alloc] init];
    item1.attributeKey = @"key1";
    item1.mask = @"mask1";
    ICLabelTemplateItem *item2 = [[ICLabelTemplateItem alloc] init];
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
