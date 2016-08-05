//
//  GCIINDetailsResponseConverter.m
//  GlobalCollectSDK
//
//  Created for Global Collect on 02/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import "GCIINDetailsResponseConverter.h"
#import "GCIINDetail.h"

@implementation GCIINDetailsResponseConverter {

}

- (GCIINDetailsResponse *)IINDetailsResponseFromJSON:(NSDictionary *)rawIINDetailsResponse {
    NSNumber *paymentProductIdNumber = rawIINDetailsResponse[@"paymentProductId"];
    NSString *paymentProductId = [NSString stringWithFormat:@"%@", paymentProductIdNumber];
    NSString *countryCode = rawIINDetailsResponse[@"countryCode"];
    BOOL allowedInContext = NO;
    if (rawIINDetailsResponse[@"isAllowedInContext"] != nil) {
        allowedInContext = [rawIINDetailsResponse[@"isAllowedInContext"] boolValue];
    }
    NSArray *coBrands = [self IINDetailsFromJSON:rawIINDetailsResponse[@"coBrands"]];

    if (paymentProductIdNumber == nil) {
        return [[GCIINDetailsResponse  alloc] initWithStatus:GCUnknown];
    }
    else if (allowedInContext == NO) {
        return [[GCIINDetailsResponse  alloc] initWithStatus:GCExistingButNotAllowed];
    }
    else {
        GCIINDetailsResponse *response = [[GCIINDetailsResponse alloc] initWithPaymentProductId:paymentProductId
                                                                                         status:GCSupported
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

- (GCIINDetail *)IINDetailFromJSON:(NSDictionary *)rawIINDetail {
    NSString *paymentProductId = [NSString stringWithFormat:@"%@", rawIINDetail[@"paymentProductId"]];
    BOOL allowedInContext = NO;
    if (rawIINDetail[@"isAllowedInContext"] != nil) {
        allowedInContext = [rawIINDetail[@"isAllowedInContext"] boolValue];
    }
    GCIINDetail *detail = [[GCIINDetail alloc] initWithPaymentProductId:paymentProductId allowedInContext:allowedInContext];
    return detail;
}

@end
