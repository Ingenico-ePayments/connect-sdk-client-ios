//
//  UIButton+GCPrimaryButton.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 05/06/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "UIButton+GCPrimaryButton.h"
#import "GCAppConstants.h"

@implementation UIButton (GCPrimaryButton)

+ (UIButton *)primaryButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.backgroundColor = kGCPrimaryColor;
    button.tintColor = [UIColor whiteColor];
    return button;
}

@end
