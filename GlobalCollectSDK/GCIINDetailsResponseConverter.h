//
//  GCIINDetailsResponseConverter.h
//  GlobalCollectSDK
//
//  Created for Global Collect on 02/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCIINDetailsResponse.h"

@interface GCIINDetailsResponseConverter : NSObject

- (GCIINDetailsResponse *)IINDetailsResponseFromJSON:(NSDictionary *)rawIINDetailsResponse;

@end
