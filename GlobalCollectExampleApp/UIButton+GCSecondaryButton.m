//
//  UIButton+GCSecondaryButton.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "UIButton+GCSecondaryButton.h"

@implementation UIButton (GCSecondaryButton)

+ (UIButton *)secondaryButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.tintColor = [UIColor grayColor];
    return button;
}

@end
