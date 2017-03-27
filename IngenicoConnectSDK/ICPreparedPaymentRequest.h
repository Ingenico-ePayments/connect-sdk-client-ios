//
//  ICPreparedPaymentRequest.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICPreparedPaymentRequest : NSObject

@property (strong, nonatomic) NSString *encryptedFields;
@property (strong, nonatomic) NSString *encodedClientMetaInfo;
           
@end
