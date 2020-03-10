//
//  ICAssetManager.m
//  IngenicoConnectSDK
//
//  Created for Ingenico ePayments on 15/12/2016.
//  Copyright © 2017 Global Collect Services. All rights reserved.
//

#import  "ICAssetManager.h"
#import  "ICSDKConstants.h"
#import  "ICMacros.h"

@interface ICAssetManager ()

@property (strong, nonatomic) NSString *logoFormat;
@property (strong, nonatomic) NSString *tooltipFormat;
@property (strong, nonatomic) NSString *documentsFolderPath;
@property (strong, nonatomic) NSFileManager *fileManager;
@property (strong, nonatomic) NSBundle *sdkBundle;

@end

@implementation ICAssetManager

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        NSString *sdkBundlePath = [[NSBundle mainBundle] pathForResource:@"IngenicoConnectSDK" ofType:@"bundle"];
        NSBundle *sdkBundle = [NSBundle bundleWithPath:sdkBundlePath];
        
        self.logoFormat = @"pp_logo_%@";
        self.tooltipFormat = @"pp_%@_tooltip_%@";
        self.fileManager = [NSFileManager defaultManager];
        self.sdkBundle = sdkBundle;
        
        /*
         An initial mapping from image identifiers to paths is stored in the bundle.
         This mapping is transferred to the device and kept up to date.
         */
        if ([StandardUserDefaults boolForKey:kICImageMappingInitialized] == NO) {
            NSString *imageMappingPath = [sdkBundle pathForResource:@"imageMapping" ofType:@"plist"];
            NSDictionary *imageMapping = [NSDictionary dictionaryWithContentsOfFile:imageMappingPath];
            [StandardUserDefaults setObject:imageMapping forKey:kICImageMapping];
            [StandardUserDefaults setBool:YES forKey:kICImageMappingInitialized];
            [StandardUserDefaults synchronize];
        }
    }
    return self;
}

- (NSString *)logoIdentifierWithPaymentItem:(NSObject<ICPaymentItem> *)paymentItem {
    NSString *path = paymentItem.displayHints.logoPath;
    NSURL *url = [[NSURL alloc] initWithString:path];
    NSString *fileName = [url lastPathComponent];
    fileName = [fileName stringByReplacingOccurrencesOfString:@".png" withString:@""];
    NSRange range = [fileName rangeOfString:@"_" options: NSBackwardsSearch];
    if (range.location != NSNotFound) {
        fileName = [fileName substringToIndex:(range.location)];
    }
    return fileName;
}

- (void)initializeImagesForPaymentItems:(NSArray *)paymentItems
{
    for (NSObject<ICPaymentItem> *paymentItem in paymentItems) {
        paymentItem.displayHints.logoImage = [self logoImageForPaymentItem:paymentItem.identifier];
    }
}

- (void)initializeImagesForPaymentItem:(NSObject<ICPaymentItem> *)paymentItem {
    paymentItem.displayHints.logoImage = [self logoImageForPaymentItem:paymentItem.identifier];
    for (ICPaymentProductField *field in paymentItem.fields.paymentProductFields) {
        if (field.displayHints.tooltip.imagePath != nil) {
            field.displayHints.tooltip.image = [self tooltipImageForPaymentItem:paymentItem.identifier field:field.identifier];
        }
    }
}

- (void)updateImagesForPaymentItemsAsynchronously:(NSArray *)paymentItems baseURL:(NSString *)baseURL
{
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(backgroundQueue, ^{
        [self updateImagesForPaymentItems:paymentItems baseURL:baseURL];
    });
}
- (void)updateImagesForPaymentItemsAsynchronously:(NSArray *)paymentItems baseURL:(NSString *)baseURL callback:(void(^)())callback
{
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(backgroundQueue, ^{
        [self updateImagesForPaymentItems:paymentItems baseURL:baseURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            callback();
        });
    });
}

- (void)updateImagesForPaymentItemAsynchronously:(NSObject<ICPaymentItem> *)paymentItem baseURL:(NSString *)baseURL
{
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(backgroundQueue, ^{
        [self updateImagesForPaymentItem:paymentItem baseURL:baseURL];
    });
}
- (void)updateImagesForPaymentItemAsynchronously:(NSObject<ICPaymentItem> *)paymentItem baseURL:(NSString *)baseURL callback:(void(^)())callback
{
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(backgroundQueue, ^{
        [self updateImagesForPaymentItem:paymentItem baseURL:baseURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            callback();
        });
    });
}


- (void)updateImagesForPaymentItems:(NSArray *)paymentItems baseURL:(NSString *)baseURL
{
    NSMutableDictionary *imageMapping = [[[NSUserDefaults standardUserDefaults] objectForKey:kICImageMapping] mutableCopy];
    for (NSObject<ICPaymentItem> *paymentItem in paymentItems) {
        NSString *identifier = [NSString stringWithFormat:self.logoFormat, paymentItem.identifier];
        [self updateImageWithIdentifier:identifier imageMapping:imageMapping newPath:paymentItem.displayHints.logoPath baseURL:baseURL];
    }
    [StandardUserDefaults setObject:imageMapping forKey:kICImageMapping];
    [StandardUserDefaults synchronize];
}

- (void)updateImagesForPaymentItem:(NSObject<ICPaymentItem> *)paymentItem baseURL:(NSString *)baseURL
{
    NSMutableDictionary *imageMapping = [[[NSUserDefaults standardUserDefaults] objectForKey:kICImageMapping] mutableCopy];
    for (ICPaymentProductField *field in paymentItem.fields.paymentProductFields) {
        if (field.displayHints.tooltip.imagePath != nil) {
            NSString *identifier = [NSString stringWithFormat:self.tooltipFormat, paymentItem.identifier, field.identifier];
            [self updateImageWithIdentifier:identifier imageMapping:imageMapping newPath:field.displayHints.tooltip.imagePath baseURL:baseURL];
        }
    }
    [StandardUserDefaults setObject:imageMapping forKey:kICImageMapping];
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
            DLog(@"Unable to save image: %@", identifier);
        } else {
            DLog(@"Error saving image: %@", [error localizedDescription]);
        }
    }
}

- (UIImage *)logoImageForPaymentItem:(NSString *)paymentItemId
{
    NSString *identifier = [NSString stringWithFormat:self.logoFormat, paymentItemId];
    return [self imageForIdentifier:identifier];
}

- (UIImage *)tooltipImageForPaymentItem:(NSString *)paymentItemId field:(NSString *)paymentProductFieldId
{
    NSString *identifier = [NSString stringWithFormat:self.tooltipFormat, paymentItemId, paymentProductFieldId];
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
