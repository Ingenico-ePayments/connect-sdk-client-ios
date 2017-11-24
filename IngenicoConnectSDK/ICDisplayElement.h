//
//  ICDisplayElement.h
//  Pods
//
//  Created for Ingenico ePayments on 19/07/2017.
//
//

#import <Foundation/Foundation.h>
#import "ICDisplayElementType.h"
@interface ICDisplayElement : NSObject
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, assign) ICDisplayElementType type;
@property (nonatomic, retain) NSString *value;
@end
