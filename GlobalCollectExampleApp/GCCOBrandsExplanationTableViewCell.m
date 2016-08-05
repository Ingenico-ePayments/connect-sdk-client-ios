//
//  GCCOBrandsExplanationTableViewCell.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 12/05/16.
//  Copyright (c) 2016 Global Collect Services B.V. All rights reserved.
//

#import "GCCOBrandsExplanationTableViewCell.h"
#import "GCSDKConstants.h"

@implementation GCCOBrandsExplanationTableViewCell {

}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.attributedText = [GCCOBrandsExplanationTableViewCell cellString];
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.numberOfLines = 0;
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    }

    return self;
}

+ (NSAttributedString *)cellString {
    UIFont *font = [UIFont systemFontOfSize:12];
    NSDictionary *fontAttribute = @{
            NSFontAttributeName: font
    };
    NSString *sdkBundlePath = [[NSBundle mainBundle] pathForResource:@"GlobalCollectSDK" ofType:@"bundle"];
    NSBundle *sdkBundle = [NSBundle bundleWithPath:sdkBundlePath];
    NSString *cellKey = @"gc.general.cobrands.introText";
    NSString *cellString = NSLocalizedStringFromTableInBundle(cellKey, kGCSDKLocalizable, sdkBundle, nil);
    NSAttributedString *cellStringWithFont = [[NSAttributedString alloc] initWithString:cellString
                                                                    attributes:fontAttribute];
    return cellStringWithFont;
}

@end
