#import <XCTest/XCTest.h>
#import <IngenicoConnectSDK/ICPaymentProductGroup.h>
#import <IngenicoConnectSDK/ICPaymentProductGroupConverter.h>
#import <IngenicoConnectSDK/ICPaymentProductFields.h>
#import <IngenicoConnectSDK/ICPaymentProductField.h>

@interface ICPaymentGroupConverterTestCase : XCTestCase

@property (strong, nonatomic) ICPaymentProductGroupConverter *converter;

@end

@implementation ICPaymentGroupConverterTestCase

- (void)setUp {
    [super setUp];
    self.converter = [ICPaymentProductGroupConverter new];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testPaymentProductGroupFromJSON
{
    NSString *paymentProductGroupPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"paymentProductGroup" ofType:@"json"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *paymentProductGroupData = [fileManager contentsAtPath:paymentProductGroupPath];
    NSDictionary *paymentProductGroupJSON = [NSJSONSerialization JSONObjectWithData:paymentProductGroupData options:0 error:NULL];
    ICPaymentProductGroup *paymentProductGroup = [self.converter paymentProductGroupFromJSON:paymentProductGroupJSON];
    XCTAssertTrue(paymentProductGroup.fields.paymentProductFields.count == 3, @"Unexpected number of fields");
    ICPaymentProductField *field = paymentProductGroup.fields.paymentProductFields[0];
    XCTAssertTrue(field.dataRestrictions.isRequired == true, @"Unexpected value for 'isRequired'");
    XCTAssertFalse(field.displayHints.alwaysShow, @"Unexpected value for 'alwaysShow'");
    XCTAssertTrue(field.displayHints.displayOrder == 0, @"Unexpected value for 'displayOrder'");
    XCTAssertTrue(field.displayHints.obfuscate == false, @"Unexpected value for 'obfuscate'");
    XCTAssertTrue([field.identifier isEqualToString:@"cardNumber"] == YES, @"Unexpected identifier");
    XCTAssertTrue(field.dataRestrictions.validators.validators.count == 0, @"Unexpected number of validators");
}

@end
