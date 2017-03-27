//
//  ICIINDetailsResponseConverter.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <IngenicoConnectSDK/ICIINDetailsResponseConverter.h>
#import <IngenicoConnectSDK/ICIINDetail.h>

@implementation ICIINDetailsResponseConverter {

}

- (ICIINDetailsResponse *)IINDetailsResponseFromJSON:(NSDictionary *)rawIINDetailsResponse {
    NSNumber *paymentProductIdNumber = rawIINDetailsResponse[@"paymentProductId"];
    NSString *paymentProductId = [NSString stringWithFormat:@"%@", paymentProductIdNumber];
    NSString *countryCode = rawIINDetailsResponse[@"countryCode"];
    BOOL allowedInContext = NO;
    if (rawIINDetailsResponse[@"isAllowedInContext"] != nil) {
        allowedInContext = [rawIINDetailsResponse[@"isAllowedInContext"] boolValue];
    }
    NSArray *coBrands = [self IINDetailsFromJSON:rawIINDetailsResponse[@"coBrands"]];

    if (paymentProductIdNumber == nil) {
        return [[ICIINDetailsResponse  alloc] initWithStatus:ICUnknown];
    }
    else if (allowedInContext == NO) {
        return [[ICIINDetailsResponse  alloc] initWithStatus:ICExistingButNotAllowed];
    }
    else {
        ICIINDetailsResponse *response = [[ICIINDetailsResponse alloc] initWithPaymentProductId:paymentProductId
                                                                                         status:ICSupported
                                                                                       coBrands:coBrands
                                                                                    countryCode:countryCode
                                                                               allowedInContext:allowedInContext];
        return response;
    }
}

- (NSArray *)IINDetailsFromJSON:(NSArray *)IINDetailsArray {
    NSMutableArray *IINDetails = [[NSMutableArray alloc] init];
    for (NSDictionary *rawIINDetail in IINDetailsArray) {
        [IINDetails addObject:[self IINDetailFromJSON:rawIINDetail]];
    }
    return [NSArray arrayWithArray:IINDetails];
}

- (ICIINDetail *)IINDetailFromJSON:(NSDictionary *)rawIINDetail {
    NSString *paymentProductId = [NSString stringWithFormat:@"%@", rawIINDetail[@"paymentProductId"]];
    BOOL allowedInContext = NO;
    if (rawIINDetail[@"isAllowedInContext"] != nil) {
        allowedInContext = [rawIINDetail[@"isAllowedInContext"] boolValue];
    }
    ICIINDetail *detail = [[ICIINDetail alloc] initWithPaymentProductId:paymentProductId allowedInContext:allowedInContext];
    return detail;
}

@end
