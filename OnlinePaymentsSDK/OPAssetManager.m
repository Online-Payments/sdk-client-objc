//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPAssetManager.h"
#import "OPSDKConstants.h"
#import "OPMacros.h"

@interface OPAssetManager ()

@property (strong, nonatomic) NSString *logoFormat;
@property (strong, nonatomic) NSString *tooltipFormat;
@property (strong, nonatomic) NSString *documentsFolderPath;
@property (strong, nonatomic) NSFileManager *fileManager;
@property (strong, nonatomic) NSBundle *sdkBundle;

@end

@implementation OPAssetManager

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        NSString *sdkBundlePath = [[NSBundle mainBundle] pathForResource:@"OnlinePaymentsSDK" ofType:@"bundle"];
        NSBundle *sdkBundle = [NSBundle bundleWithPath:sdkBundlePath];
        
        self.logoFormat = @"pp_logo_%@";
        self.tooltipFormat = @"pp_%@_tooltip_%@";
        self.fileManager = [NSFileManager defaultManager];
        self.sdkBundle = sdkBundle;
        
        /*
         An initial mapping from image identifiers to paths is stored in the bundle.
         This mapping is transferred to the device and kept up to date.
         */
        if ([StandardUserDefaults boolForKey:kOPImageMappingInitialized] == NO) {
            NSString *imageMappingPath = [sdkBundle pathForResource:@"imageMapping" ofType:@"plist"];
            NSDictionary *imageMapping = [NSDictionary dictionaryWithContentsOfFile:imageMappingPath];
            [StandardUserDefaults setObject:imageMapping forKey:kOPImageMapping];
            [StandardUserDefaults setBool:YES forKey:kOPImageMappingInitialized];
            [StandardUserDefaults synchronize];
        }
    }
    return self;
}

- (NSString *)logoIdentifierWithPaymentItem:(NSObject<OPPaymentItem> *)paymentItem {
    if (paymentItem.displayHintsList != nil) {
        NSString *path = paymentItem.displayHintsList[0].logoPath;
        NSURL *url = [[NSURL alloc] initWithString:path];
        NSString *fileName = [url lastPathComponent];
        fileName = [fileName stringByReplacingOccurrencesOfString:@".png" withString:@""];
        NSRange range = [fileName rangeOfString:@"_" options: NSBackwardsSearch];
        if (range.location != NSNotFound) {
            fileName = [fileName substringToIndex:(range.location)];
        }
        return fileName;
    } else {
        return nil;
    }
}

- (void)initializeImagesForPaymentItems:(NSArray *)paymentItems
{
    for (NSObject<OPPaymentItem> *paymentItem in paymentItems) {
        if (paymentItem.displayHintsList != nil) {
            paymentItem.displayHintsList[0].logoImage = [self logoImageForPaymentItem:paymentItem.identifier];
        }
    }
}

- (void)initializeImagesForPaymentItem:(NSObject<OPPaymentItem> *)paymentItem {
    if (paymentItem.displayHintsList != nil) {
        paymentItem.displayHintsList[0].logoImage = [self logoImageForPaymentItem:paymentItem.identifier];
    }
    for (OPPaymentProductField *field in paymentItem.fields.paymentProductFields) {
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
- (void)updateImagesForPaymentItemsAsynchronously:(NSArray *)paymentItems baseURL:(NSString *)baseURL callback:(void(^)(void))callback
{
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(backgroundQueue, ^{
        [self updateImagesForPaymentItems:paymentItems baseURL:baseURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            callback();
        });
    });
}

- (void)updateImagesForPaymentItemAsynchronously:(NSObject<OPPaymentItem> *)paymentItem baseURL:(NSString *)baseURL
{
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(backgroundQueue, ^{
        [self updateImagesForPaymentItem:paymentItem baseURL:baseURL];
    });
}
- (void)updateImagesForPaymentItemAsynchronously:(NSObject<OPPaymentItem> *)paymentItem baseURL:(NSString *)baseURL callback:(void(^)(void))callback
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
    NSMutableDictionary *imageMapping = [[[NSUserDefaults standardUserDefaults] objectForKey:kOPImageMapping] mutableCopy];
    for (NSObject<OPPaymentItem> *paymentItem in paymentItems) {
        if (paymentItem.displayHintsList != nil) {
            NSString *identifier = [NSString stringWithFormat:self.logoFormat, paymentItem.identifier];
            [self updateImageWithIdentifier:identifier imageMapping:imageMapping newPath:paymentItem.displayHintsList[0].logoPath baseURL:baseURL];
        }
    }
    [StandardUserDefaults setObject:imageMapping forKey:kOPImageMapping];
    [StandardUserDefaults synchronize];
}

- (void)updateImagesForPaymentItem:(NSObject<OPPaymentItem> *)paymentItem baseURL:(NSString *)baseURL
{
    NSMutableDictionary *imageMapping = [[[NSUserDefaults standardUserDefaults] objectForKey:kOPImageMapping] mutableCopy];
    for (OPPaymentProductField *field in paymentItem.fields.paymentProductFields) {
        if (field.displayHints.tooltip.imagePath != nil) {
            NSString *identifier = [NSString stringWithFormat:self.tooltipFormat, paymentItem.identifier, field.identifier];
            [self updateImageWithIdentifier:identifier imageMapping:imageMapping newPath:field.displayHints.tooltip.imagePath baseURL:baseURL];
        }
    }
    [StandardUserDefaults setObject:imageMapping forKey:kOPImageMapping];
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

- (void) getLogoByStringURL:(NSString *)url callback:(void (^)(UIImage *))callback
{
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSString *urlString = [url stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlString]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData: data];
            callback(image);
        });
    });
}
@end
