//
//  GCIINStatus.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 02/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#ifndef GlobalCollectExampleApp_GCIINStatus_h
#define GlobalCollectExampleApp_GCIINStatus_h

typedef enum {
    GCSupported,
    GCUnsupported,
    GCUnknown,
    GCNotEnoughDigits,
    GCPending,
    GCExistingButNotAllowed
} GCIINStatus;

#endif
