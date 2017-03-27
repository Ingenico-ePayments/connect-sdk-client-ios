#import <XCTest/XCTest.h>
#import <IngenicoConnectSDK/ICPaymentItemDisplayHints.h>
#import <IngenicoConnectSDK/ICBasicPaymentProductGroup.h>
#import <IngenicoConnectSDK/ICPaymentProductGroupsConverter.h>
#import <IngenicoConnectSDK/ICBasicPaymentProductGroups.h>

@interface ICPaymentGroupsConverterTestCase : XCTestCase

@property (nonatomic, strong) ICPaymentProductGroupsConverter *converter;

@end

@implementation ICPaymentGroupsConverterTestCase

- (void)setUp {
    [super setUp];
    self.converter = [ICPaymentProductGroupsConverter new];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testPaymentProductGroupsFromJSON {
    NSString *paymentProductGroupsPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"paymentProductGroups" ofType:@"json"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *paymentProductGroupsData = [fileManager contentsAtPath:paymentProductGroupsPath];
    NSDictionary *paymentProductGroupsJSON = [NSJSONSerialization JSONObjectWithData:paymentProductGroupsData options:0 error:NULL];
    ICBasicPaymentProductGroups *paymentProductGroups = [self.converter paymentProductGroupsFromJSON:paymentProductGroupsJSON[@"paymentProductGroups"]];
    if (paymentProductGroups.paymentProductGroups.count != 1) {
        XCTFail(@"Wrong number of payment products.");
    }
    for (ICBasicPaymentProductGroup *product in paymentProductGroups.paymentProductGroups) {
        XCTAssertNotNil(product.identifier, @"Payment product has no identifier");
        XCTAssertNotNil(product.displayHints, @"Payment product has no displayHints");
        XCTAssertNotNil(product.displayHints.logoPath, @"Payment product has no logo path in displayHints");
    }

}

@end
