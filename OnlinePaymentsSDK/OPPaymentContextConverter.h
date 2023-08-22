//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OPPaymentContext;

__deprecated_msg("In a future release, this interface and its functions will become internal to the SDK.")
@interface OPPaymentContextConverter : NSObject

- (NSDictionary *)JSONFromPaymentProductContext:(OPPaymentContext *)paymentProductContext partialCreditCardNumber:(NSString *)partialCreditCardNumber;
- (NSDictionary *)JSONFromPartialCreditCardNumber:(NSString *)partialCreditCardNumber;

@end
