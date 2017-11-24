//
//  DisplayElementsConverter.m
//  Pods
//
//  Created for Ingenico ePayments on 19/07/2017.
//
//

#import "ICDisplayElementsConverter.h"
#import "ICDisplayElement.h"
@implementation ICDisplayElementsConverter
// TODO type
-(NSArray<ICDisplayElement *> *)displayElementsFromJSON:(NSArray *)json
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in json)
    {
        [arr addObject:[self displayElementFromJSON:dict]];
    }
    return arr;
}
-(ICDisplayElement *)displayElementFromJSON:(NSDictionary *)dict
{
    ICDisplayElement *element = [[ICDisplayElement alloc]init];
    element.identifier = dict[@"id"];
    element.value = dict[@"value"];
    NSString *elementType = dict[@"type"];
    if ([elementType isEqualToString:@"STRING"]) {
        element.type = ICDisplayElementTypeString;
    }
    else if ([elementType isEqualToString:@"CURRENCY"])
    {
        element.type = ICDisplayElementTypeCurrency;

    }
    else if ([elementType isEqualToString:@"PERCENTAGE"])
    {
        element.type = ICDisplayElementTypePercentage;

    }
    else if ([elementType isEqualToString:@"URI"])
    {
        element.type = ICDisplayElementTypeURI;

    }
    else if ([elementType isEqualToString:@"INTEGER"])
    {
        element.type = ICDisplayElementTypeInteger;

    }

    return element;
    
}
@end
