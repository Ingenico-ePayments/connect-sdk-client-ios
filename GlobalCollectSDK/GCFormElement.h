//
//  GCFormElement.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 14/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCFormElementType.h"

@interface GCFormElement : NSObject

@property (nonatomic) GCFormElementType type;
@property (strong, nonatomic) NSMutableArray *valueMapping;

@end
