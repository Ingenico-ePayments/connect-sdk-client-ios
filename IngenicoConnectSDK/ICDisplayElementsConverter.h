//
//  DisplayElementsConverter.h
//  Pods
//
//  Created for Ingenico ePayments on 19/07/2017.
//
//

#import <Foundation/Foundation.h>
@class ICDisplayElement;
@interface ICDisplayElementsConverter : NSObject
-(ICDisplayElement *)displayElementFromJSON:(NSDictionary *)json;
-(NSArray<ICDisplayElement *> *)displayElementsFromJSON:(NSArray *)json;
@end
