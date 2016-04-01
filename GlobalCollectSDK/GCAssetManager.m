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
@property (strong, nonatomic) NSBundle *sdkBundle;

@end

@implementation GCAssetManager

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        NSString *sdkBundlePath = [[NSBundle mainBundle] pathForResource:@"GlobalCollectSDK" ofType:@"bundle"];
        NSBundle *sdkBundle = [NSBundle bundleWithPath:sdkBundlePath];
        
        self.logoFormat = @"pp_logo_%@";
        self.tooltipFormat = @"pp_%@_tooltip_%@";
        self.fileManager = [NSFileManager defaultManager];
        self.sdkBundle = sdkBundle;
        
        /*
         An initial mapping from image identifiers to paths is stored in the bundle.
         This mapping is transferred to the device and kept up to date.
         */
        if ([StandardUserDefaults boolForKey:kGCImageMappingInitialized] == NO) {
            NSString *imageMappingPath = [sdkBundle pathForResource:@"imageMapping" ofType:@"plist"];
            NSDictionary *imageMapping = [NSDictionary dictionaryWithContentsOfFile:imageMappingPath];
            [StandardUserDefaults setObject:imageMapping forKey:kGCImageMapping];
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
        
        /*
         A new image for this identifier is available. Update the mapping
         from image identifiers to paths on the device, and store the new
         image in the documents folder.
         */
        NSString *newURL = [NSString stringWithFormat:@"%@/%@", baseURL, newPath];
        NSString *imagePath = [NSString stringWithFormat:@"%@/%@", DocumentsFolderPath, identifier];
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:newURL]];
        BOOL success = [data writeToFile:imagePath options:0 error:&error];
        if (success == YES && error == nil) {
            [imageMapping setObject:newPath forKey:identifier];
        } else if (success == NO) {
            DLog(@"Unable to save image");
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
    /*
     If an image for this identifier is available in the documents folder,
     this image is newer than the one in the bundle and should be used.
     */
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@", DocumentsFolderPath, identifier];
    if ([self.fileManager fileExistsAtPath:imagePath] == YES) {
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        return image;
    }
    
    /*
     If there's no updated image available in the documents folder,
     use the one in the bundle.
     */
    imagePath = [self.sdkBundle pathForResource:identifier ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

@end