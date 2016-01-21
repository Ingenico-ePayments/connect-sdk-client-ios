//
//  GCFormRowSwitch.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 10/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCFormRow.h"
#import "GCSwitch.h"

@interface GCFormRowSwitch : GCFormRow

@property (strong, nonatomic) GCSwitch* switchControl;
@property (strong, nonatomic) NSString *text;

@end
