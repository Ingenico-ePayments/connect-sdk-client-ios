//
//  ICEnvironment.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#ifndef IngenicoConnectSDKExample_ICEnvironment_h
#define IngenicoConnectSDKExample_ICEnvironment_h

DEPRECATED_ATTRIBUTE __deprecated_msg("Use the clientApiUrl and assetUrl returned in the Server to Server Create Client Session API to determine the connection endpoints.")
typedef enum {
    ICProduction,
    ICPreProduction,
    ICSandbox,
} ICEnvironment;

#endif
