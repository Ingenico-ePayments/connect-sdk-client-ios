//
//  GCFormRowsConverter.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 10/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCPaymentRequest.h"
#import "GCViewFactory.h"

@class GCIINDetailsResponse;
@class GCPaymentProductInputData;

@interface GCFormRowsConverter : NSObject

- (NSMutableArray *)formRowsFromInputData:(GCPaymentProductInputData *)inputData iinDetailsResponse:(GCIINDetailsResponse *)iinDetailsResponse validation:(BOOL)validation viewFactory:(GCViewFactory *)viewFactory confirmedPaymentProducts:(NSSet *)confirmedPaymentProducts;

@end
