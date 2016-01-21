//
//  GCSecondaryButton.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCSecondaryButton.h"

@implementation GCSecondaryButton

- (instancetype)init
{
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tintColor = [UIColor grayColor];
    }
    return self;
}

@end
