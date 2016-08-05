//
//  GCCoBrandsSelectionTableViewCell.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 09/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import "GCCoBrandsSelectionTableViewCell.h"
#import "GCSDKConstants.h"

@implementation GCCoBrandsSelectionTableViewCell {

}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        UIFont *font = [UIFont systemFontOfSize:13];
        NSDictionary *underlineAttribute = @{
                NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                NSFontAttributeName: font
        };

        NSString *sdkBundlePath = [[NSBundle mainBundle] pathForResource:@"GlobalCollectSDK" ofType:@"bundle"];
        NSBundle *sdkBundle = [NSBundle bundleWithPath:sdkBundlePath];
        NSString *cobrandsKey = @"gc.general.cobrands.toggleCobrands";
        NSString *cobrandsString = NSLocalizedStringFromTableInBundle(cobrandsKey, kGCSDKLocalizable, sdkBundle, nil);
        self.textLabel.attributedText = [[NSAttributedString alloc] initWithString:cobrandsString
                                                                 attributes:underlineAttribute];
        self.textLabel.textAlignment = NSTextAlignmentRight;
    }

    return self;
}

@end
