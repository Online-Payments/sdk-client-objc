//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OPPaymentProductFieldDisplayHints.h"
#import "OPDataRestrictions.h"
#import "OPType.h"

@class OPPaymentRequest;

@interface OPPaymentProductField : NSObject

@property (strong, nonatomic) OPDataRestrictions *dataRestrictions;
@property (strong, nonatomic) OPPaymentProductFieldDisplayHints *displayHints;
@property (strong, nonatomic) NSString *identifier;
@property (assign, nonatomic) BOOL usedForLookup;
@property (nonatomic) OPType type;
@property (strong, nonatomic) NSMutableArray *errors;

- (instancetype)init DEPRECATED_ATTRIBUTE __deprecated_msg("This initialiser is meant for internal SDK usage and should not be used. In the future this contract may change without warning.");

- (void)validateValue:(NSString *)value DEPRECATED_ATTRIBUTE;
- (void)validateValue:(NSString *)value forPaymentRequest:(OPPaymentRequest *)request;

@end
