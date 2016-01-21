//
//  GCDirectoryEntry.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 17/03/15.
//  Copyright (c) 2015 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDirectoryEntry : NSObject

@property (strong, nonatomic) NSMutableArray *countryNames;
@property (strong, nonatomic) NSString *issuerIdentifier;
@property (strong, nonatomic) NSString *issuerList;
@property (strong, nonatomic) NSString *issuerName;

@end
