//
//  ICFormElement.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <IngenicoConnectSDK/ICFormElementType.h>

@interface ICFormElement : NSObject

@property (nonatomic) ICFormElementType type;
@property (strong, nonatomic) NSMutableArray *valueMapping;

@end
