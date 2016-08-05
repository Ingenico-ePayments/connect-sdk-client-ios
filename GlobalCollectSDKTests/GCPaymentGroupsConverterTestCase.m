#import <XCTest/XCTest.h>
#import "GCPaymentItemDisplayHints.h"
#import "GCBasicPaymentProductGroup.h"
#import "GCPaymentProductGroupsConverter.h"
#import "GCBasicPaymentProductGroups.h"

@interface GCPaymentGroupsConverterTestCase : XCTestCase

@property (nonatomic, strong) GCPaymentProductGroupsConverter *converter;

@end

@implementation GCPaymentGroupsConverterTestCase

- (void)setUp {
    [super setUp];
    self.converter = [GCPaymentProductGroupsConverter new];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testPaymentProductGroupsFromJSON {
    NSString *paymentProductGroupsPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"paymentProductGroups" ofType:@"json"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *paymentProductGroupsData = [fileManager contentsAtPath:paymentProductGroupsPath];
    NSDictionary *paymentProductGroupsJSON = [NSJSONSerialization JSONObjectWithData:paymentProductGroupsData options:0 error:NULL];
    GCBasicPaymentProductGroups *paymentProductGroups = [self.converter paymentProductGroupsFromJSON:paymentProductGroupsJSON[@"paymentProductGroups"]];
    if (paymentProductGroups.paymentProductGroups.count != 1) {
        XCTFail(@"Wrong number of payment products.");
    }
    for (GCBasicPaymentProductGroup *product in paymentProductGroups.paymentProductGroups) {
        XCTAssertNotNil(product.identifier, @"Payment product has no identifier");
        XCTAssertNotNil(product.displayHints, @"Payment product has no displayHints");
        XCTAssertNotNil(product.displayHints.logoPath, @"Payment product has no logo path in displayHints");
    }

}

@end
