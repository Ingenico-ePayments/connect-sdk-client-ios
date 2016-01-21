//
//  GCAccountsOnFile.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCAccountOnFile.h"

@interface GCAccountsOnFile : NSObject

@property (strong, nonatomic) NSMutableArray *accountsOnFile;

- (GCAccountOnFile *)accountOnFileWithIdentifier:(NSString *)accountOnFileIdentifier;

@end
