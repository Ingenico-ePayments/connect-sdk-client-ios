//
//  GCDirectoryEntriesConverter.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 17/03/15.
//  Copyright (c) 2015 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCDirectoryEntries.h"

@interface GCDirectoryEntriesConverter : NSObject

- (GCDirectoryEntries *)directoryEntriesFromJSON:(NSArray *)rawDirectoryEntries;

@end
