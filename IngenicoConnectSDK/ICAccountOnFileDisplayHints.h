//
//  ICAccountOnFileDisplayHints.h
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import  "ICLabelTemplate.h"

@interface ICAccountOnFileDisplayHints : NSObject

@property (strong, nonatomic) ICLabelTemplate *labelTemplate;
@property (strong, nonatomic) NSString *logo;

@end
