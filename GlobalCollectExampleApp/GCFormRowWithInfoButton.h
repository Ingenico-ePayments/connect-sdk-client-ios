//
//  GCFormRowWithInfoButton.h
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 20/10/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCFormRow.h"

@interface GCFormRowWithInfoButton : GCFormRow

@property (nonatomic) BOOL showInfoButton;
@property (strong, nonatomic) UIImage *tooltipImage;
@property (strong, nonatomic) NSString *tooltipText;

@end
