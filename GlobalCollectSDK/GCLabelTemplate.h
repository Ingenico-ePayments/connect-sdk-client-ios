//
//  GCLabelTemplate.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 14/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCLabelTemplate : NSObject

@property (strong, nonatomic) NSMutableArray *labelTemplateItems;

- (NSString *)maskForAttributeKey:(NSString *)key;

@end
