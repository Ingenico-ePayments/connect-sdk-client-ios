//
//  GCPrimaryButton.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCPrimaryButton.h"
#import "GCAppConstants.h"

@implementation GCPrimaryButton

- (instancetype)init
{
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.backgroundColor = kGCPrimaryColor;
        self.tintColor = [UIColor whiteColor];
    }
    return self;
}

@end
