//
//  GCAccountOnFileAttributes.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 06/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCAccountOnFileAttributes : NSObject

@property (strong, nonatomic) NSMutableArray *attributes;

- (NSString *)valueForField:(NSString *)paymentProductFieldId;
- (BOOL)hasValueForField:(NSString *)paymentProductFieldId;
- (BOOL)fieldIsReadOnly:(NSString *)paymentProductFieldId;

@end
