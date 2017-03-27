#import <IngenicoConnectSDK/ICAccountsOnFile.h>
#import <IngenicoConnectSDK/ICPaymentItemDisplayHints.h>
#import <IngenicoConnectSDK/ICBasicPaymentProductGroup.h>
#import <XCTest/XCTest.h>
#import <IngenicoConnectSDK/ICBasicPaymentProductGroupConverter.h>

@interface ICBasicPaymentGroupConverterTestCase : XCTestCase

@property (strong, nonatomic) ICBasicPaymentProductGroupConverter *converter;

@end

@implementation ICBasicPaymentGroupConverterTestCase

- (void)setUp {
    [super setUp];
    self.converter = [ICBasicPaymentProductGroupConverter new];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testBasicPaymentProductGroupFromJSON {
    NSString *paymentProductGroupPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"paymentProductGroup" ofType:@"json"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *paymentProductGroupData = [fileManager contentsAtPath:paymentProductGroupPath];
    NSDictionary *paymentProductGroupJSON = [NSJSONSerialization JSONObjectWithData:paymentProductGroupData options:0 error:NULL];
    ICBasicPaymentProductGroup *paymentProductGroup = [self.converter paymentProductGroupFromJSON:paymentProductGroupJSON];
    XCTAssertTrue([paymentProductGroup.identifier isEqualToString:@"card"] == YES, @"Payment product has an unexpected identifier");
    XCTAssertNotNil(paymentProductGroup.displayHints.logoPath, @"Display hints of payment product has no logo path");
    XCTAssertTrue(paymentProductGroup.accountsOnFile.accountsOnFile.count == 0, @"Unexpected number of accounts on file");
}

@end
