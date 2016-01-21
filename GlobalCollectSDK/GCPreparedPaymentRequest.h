//
//  GCPreparedPaymentRequest.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 02/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCPreparedPaymentRequest : NSObject

@property (strong, nonatomic) NSString *encryptedFields;
@property (strong, nonatomic) NSString *encodedClientMetaInfo;
           
@end
