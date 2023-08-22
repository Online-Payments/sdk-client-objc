//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPLabelTemplate : NSObject

@property (strong, nonatomic) NSMutableArray *labelTemplateItems;

- (instancetype)init DEPRECATED_ATTRIBUTE __deprecated_msg("This initialiser is meant for internal SDK usage and should not be used. In the future this contract may change without warning.");

- (NSString *)maskForAttributeKey:(NSString *)key;

@end
