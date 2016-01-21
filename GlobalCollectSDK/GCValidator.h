//
//  GCValidator.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCValidator : NSObject

@property (strong, nonatomic) NSMutableArray *errors;

- (void)validate:(NSString *)value;

@end
