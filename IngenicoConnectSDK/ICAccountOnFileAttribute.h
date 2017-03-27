//
//  ICAccountOnFileAttribute.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IngenicoConnectSDK/ICAccountOnFileAttributeStatus.h>

@interface ICAccountOnFileAttribute : NSObject

@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *value;
@property (strong, nonatomic) NSString *formattedValue;
@property (nonatomic) ICAccountOnFileAttributeStatus status;
@property (nonatomic) NSString *mustWriteReason;

@end
