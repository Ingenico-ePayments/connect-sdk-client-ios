//
//  GCAccountOnFileAttribute.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 06/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCAccountOnFileAttributeStatus.h"

@interface GCAccountOnFileAttribute : NSObject

@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *value;
@property (strong, nonatomic) NSString *formattedValue;
@property (nonatomic) GCAccountOnFileAttributeStatus status;
@property (nonatomic) NSString *mustWriteReason;

@end
