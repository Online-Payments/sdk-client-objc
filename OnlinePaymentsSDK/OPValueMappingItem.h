//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <Foundation/Foundation.h>

@class OPDisplayElement;

@interface OPValueMappingItem : NSObject

@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSArray<OPDisplayElement *>* displayElements;
@property (strong, nonatomic) NSString *value;

- (instancetype)init DEPRECATED_ATTRIBUTE __deprecated_msg("This initialiser is meant for internal SDK usage and should not be used. In the future this contract may change without warning.");

@end
