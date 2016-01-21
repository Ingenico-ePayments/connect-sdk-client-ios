//
//  GCFractionalTextField.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 20/10/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCFractionalTextField.h"

@implementation GCFractionalTextField

- (instancetype)init
{
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    CGRect rect = [super rightViewRectForBounds:bounds];
    rect.origin.x -= 10;
    return rect;
}

@end
