//
//  GCPaymentProductSelectionTarget.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 06/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCPaymentType.h"
#import "GCBasicPaymentProduct.h"
#import "GCAccountOnFile.h"

@protocol GCPaymentProductSelectionTarget <NSObject>

- (void)didSelectPaymentProduct:(GCBasicPaymentProduct *)paymentProduct accountOnFile:(GCAccountOnFile *)accountOnFile;

@end
