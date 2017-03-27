//
//  ICDirectoryEntry.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICDirectoryEntry : NSObject

@property (strong, nonatomic) NSMutableArray *countryNames;
@property (strong, nonatomic) NSString *issuerIdentifier;
@property (strong, nonatomic) NSString *issuerList;
@property (strong, nonatomic) NSString *issuerName;

@end
