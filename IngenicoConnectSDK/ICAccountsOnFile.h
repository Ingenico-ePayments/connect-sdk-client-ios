//
//  ICAccountsOnFile.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import  "ICAccountOnFile.h"

@interface ICAccountsOnFile : NSObject

@property (strong, nonatomic) NSMutableArray *accountsOnFile;

- (ICAccountOnFile *)accountOnFileWithIdentifier:(NSString *)accountOnFileIdentifier;

@end
