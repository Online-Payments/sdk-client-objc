//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import  "OPBasicPaymentProduct.h"
#import  "OPAssetManager.h"
#import  "OPStringFormatter.h"
#import  "OPBasicPaymentItemConverter.h"

__deprecated_msg("In a future release, this interface and its functions will become internal to the SDK.")
@interface OPBasicPaymentProductConverter : OPBasicPaymentItemConverter

- (OPBasicPaymentProduct *)basicPaymentProductFromJSON:(NSDictionary *)rawBasicProduct;
- (void)setBasicPaymentProduct:(OPBasicPaymentProduct *)basicProduct JSON:(NSDictionary *)rawBasicProduct;

@end
