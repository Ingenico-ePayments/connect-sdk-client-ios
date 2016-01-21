//
//  GCAssetManager.m
//  GlobalCollectExampleApp
//
//  Created for Global Collect on 03/07/14.
//  Copyright (c) 2014 Global Collect Services B.V. All rights reserved.
//

#import "GCAssetManager.h"
#import "GCSDKConstants.h"
#import "GCMacros.h"

@interface GCAssetManager ()

@property (strong, nonatomic) NSString *logoFormat;
@property (strong, nonatomic) NSString *tooltipFormat;
@property (strong, nonatomic) NSString *documentsFolderPath;
@property (strong, nonatomic) NSFileManager *fileManager;

@end

@implementation GCAssetManager

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.logoFormat = @"pp_logo_%@";
        self.tooltipFormat = @"pp_%@_tooltip_%@";
        self.fileManager = [NSFileManager defaultManager];
        if ([StandardUserDefaults boolForKey:kGCImageMappingInitialized] == NO) {
            NSDictionary *logoMapping = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"images" ofType:@"plist"]];
            [StandardUserDefaults setObject:logoMapping forKey:kGCImageMapping];
            [StandardUserDefaults setBool:YES forKey:kGCImageMappingInitialized];
            [StandardUserDefaults synchronize];
        }
    }
    return self;
}

- (void)initializeImagesForPaymentProducts:(GCPaymentProducts *)paymentProducts
{
    for (GCBasicPaymentProduct *basicPaymentProduct in paymentProducts.paymentProducts) {
        basicPaymentProduct.displayHints.logoImage = [self logoImageForPaymentProduct:basicPaymentProduct.identifier];
    }
}

- (void)initializeImagesForPaymentProduct:(GCPaymentProduct *)paymentProduct
{
    paymentProduct.displayHints.logoImage = [self logoImageForPaymentProduct:paymentProduct.identifier];
    for (GCPaymentProductField *field in paymentProduct.fields.paymentProductFields) {
        if (field.displayHints.tooltip.imagePath != nil) {
            field.displayHints.tooltip.image = [self tooltipImageForPaymentProduct:paymentProduct.identifier field:field.identifier];
        }
    }
}

- (void)updateImagesForPaymentProductsAsynchronously:(GCPaymentProducts *)paymentProducts baseURL:(NSString *)baseURL
{
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(backgroundQueue, ^{
        [self updateImagesForPaymentProducts:paymentProducts baseURL:baseURL];
    });
}

- (void)updateImagesForPaymentProductAsynchronously:(GCPaymentProduct *)paymentProduct baseURL:(NSString *)baseURL
{
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(backgroundQueue, ^{
        [self updateImagesForPaymentProduct:paymentProduct baseURL:baseURL];
    });
}


- (void)updateImagesForPaymentProducts:(GCPaymentProducts *)paymentProducts baseURL:(NSString *)baseURL
{
    NSMutableDictionary *imageMapping = [[[NSUserDefaults standardUserDefaults] objectForKey:kGCImageMapping] mutableCopy];
    for (GCBasicPaymentProduct *basicPaymentProduct in paymentProducts.paymentProducts) {
        NSString *identifier = [NSString stringWithFormat:self.logoFormat, basicPaymentProduct.identifier];
        [self updateImageWithIdentifier:identifier imageMapping:imageMapping newPath:basicPaymentProduct.displayHints.logoPath baseURL:baseURL];
    }
    [StandardUserDefaults setObject:imageMapping forKey:kGCImageMapping];
    [StandardUserDefaults synchronize];
}

- (void)updateImagesForPaymentProduct:(GCPaymentProduct *)paymentProduct baseURL:(NSString *)baseURL
{
    NSMutableDictionary *imageMapping = [[[NSUserDefaults standardUserDefaults] objectForKey:kGCImageMapping] mutableCopy];
    for (GCPaymentProductField *field in paymentProduct.fields.paymentProductFields) {
        if (field.displayHints.tooltip.imagePath != nil) {
            NSString *identifier = [NSString stringWithFormat:self.tooltipFormat, paymentProduct.identifier, field.identifier];
            [self updateImageWithIdentifier:identifier imageMapping:imageMapping newPath:field.displayHints.tooltip.imagePath baseURL:baseURL];
        }
    }
    [StandardUserDefaults setObject:imageMapping forKey:kGCImageMapping];
    [StandardUserDefaults synchronize];
}

- (void)updateImageWithIdentifier:(NSString *)identifier imageMapping:(NSMutableDictionary *)imageMapping newPath:(NSString *)newPath baseURL:(NSString *)baseURL
{
    NSString *currentPath;
    if ([imageMapping objectForKey:identifier] != nil) {
        currentPath = [imageMapping objectForKey:identifier];
    } else {
        currentPath = @"";
    }
    if ([currentPath isEqualToString:newPath] == NO) {
        NSString *newURL = [NSString stringWithFormat:@"%@%@", baseURL, newPath];
        NSString *imagePath = [NSString stringWithFormat:@"%@/%@", DocumentsFolderPath, identifier];
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:newURL]];
        [data writeToFile:imagePath options:NSDataWritingAtomic error:&error];
        if (error == nil) {
            [imageMapping setObject:newPath forKey:identifier];
        } else {
            DLog(@"Error saving image: %@", [error localizedDescription]);
        }
    }
}

- (UIImage *)logoImageForPaymentProduct:(NSString *)paymentProductId
{
    NSString *identifier = [NSString stringWithFormat:self.logoFormat, paymentProductId];
    return [self imageForIdentifier:identifier];
}

- (UIImage *)tooltipImageForPaymentProduct:(NSString *)paymentProductId field:(NSString *)paymentProductFieldId
{
    NSString *identifier = [NSString stringWithFormat:self.tooltipFormat, paymentProductId, paymentProductFieldId];
    return [self imageForIdentifier:identifier];
}

- (UIImage *)imageForIdentifier:(NSString *)identifier
{
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@", DocumentsFolderPath, identifier];
    if ([self.fileManager fileExistsAtPath:imagePath] == YES) {
        return [UIImage imageWithContentsOfFile:imagePath];
    }
    return [UIImage imageNamed:identifier];
}

@end
