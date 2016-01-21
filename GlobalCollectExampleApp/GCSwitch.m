//
//  GCSwitch.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCSwitch.h"
#import "GCAppConstants.h"

@implementation GCSwitch

- (instancetype)init
{
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.onTintColor = kGCPrimaryColor;
    return self;
}

@end
