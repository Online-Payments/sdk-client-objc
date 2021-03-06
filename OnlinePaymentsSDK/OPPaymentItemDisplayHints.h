//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPPaymentItemDisplayHints : NSObject

@property (nonatomic) NSUInteger displayOrder;
@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) NSString *logoPath;
@property (strong, nonatomic) UIImage *logoImage;

@end
