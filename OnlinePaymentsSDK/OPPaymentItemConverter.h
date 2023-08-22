//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  "OPBasicPaymentItemConverter.h"

@protocol OPPaymentItem;

__deprecated_msg("In a future release, this interface and its functions will become internal to the SDK.")
@interface OPPaymentItemConverter : OPBasicPaymentItemConverter

- (void)setPaymentItem:(NSObject <OPPaymentItem> *)paymentItem JSON:(NSDictionary *)rawPaymentItem;
- (void)setPaymentProductFields:(OPPaymentProductFields *)fields JSON:(NSArray *)rawFields;

@end
