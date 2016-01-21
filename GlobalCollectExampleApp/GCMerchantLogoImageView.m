//
//  GCMerchantLogoImageView.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 09/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCMerchantLogoImageView.h"

@implementation GCMerchantLogoImageView

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, 20, 20)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *logo = [UIImage imageNamed:@"MerchantLogo"];
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.image = logo;
    }
    return self;
}

@end
