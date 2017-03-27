//
//  ICDirectoryEntriesConverter.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <IngenicoConnectSDK/ICDirectoryEntries.h>

@interface ICDirectoryEntriesConverter : NSObject

- (ICDirectoryEntries *)directoryEntriesFromJSON:(NSArray *)rawDirectoryEntries;

@end
