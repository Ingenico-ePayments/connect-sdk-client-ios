//
//  GCTextField.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 12/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCTextField.h"

@implementation GCTextField

- (instancetype)init
{
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.borderStyle = UITextBorderStyleRoundedRect;
    }
    return self;
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    CGRect rect = [super rightViewRectForBounds:bounds];
    rect.origin.x -= 10;
    return rect;
}

@end
