//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <Foundation/Foundation.h>

#import "OPBasicPaymentProducts.h"
#import "OPPaymentProduct.h"

@class OPPaymentItems;

__deprecated_msg("In a future release this class, its functions and its properties will be removed. Instead please retrieve the logo / tooltip image directly from the OPPaymentItem.\nIf an image is not available, or you wish to retrieve it again, you can retrieve it from the logo's / tooltip image's URL that is also stored in the OPPaymentItem.")
@interface OPAssetManager : NSObject

- (void)initializeImagesForPaymentItems:(NSArray *)paymentItems;
- (void)initializeImagesForPaymentItem:(NSObject<OPPaymentItem> *)paymentItem;
- (void)updateImagesForPaymentItemsAsynchronously:(NSArray *)paymentItems baseURL:(NSString *)baseURL;
- (void)updateImagesForPaymentItemAsynchronously:(NSObject<OPPaymentItem> *)paymentItem baseURL:(NSString *)baseURL;
- (void)updateImagesForPaymentItemsAsynchronously:(NSArray *)paymentItems baseURL:(NSString *)baseURL callback:(void(^)(void))callback;
- (void)updateImagesForPaymentItemAsynchronously:(NSObject<OPPaymentItem> *)paymentItem baseURL:(NSString *)baseURL callback:(void(^)(void))callback;
- (UIImage *)logoImageForPaymentItem:(NSString *)paymentItemId;
- (UIImage *)tooltipImageForPaymentItem:(NSString *)paymentItemId field:(NSString *)paymentProductFieldId;
- (void)getLogoByStringURL:(NSString *) url callback:(void (^)(UIImage *image))callback;

@end
