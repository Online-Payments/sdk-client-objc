//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "OPAccountOnFileAttributeStatus.h"

@interface OPAccountOnFileAttribute : NSObject

@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *value;
@property (strong, nonatomic) NSString *formattedValue;
@property (nonatomic) OPAccountOnFileAttributeStatus status;
@property (nonatomic) NSString *mustWriteReason;

- (instancetype)init DEPRECATED_ATTRIBUTE __deprecated_msg("This initialiser is meant for internal SDK usage and should not be used. In the future this contract may change without warning.");

@end
