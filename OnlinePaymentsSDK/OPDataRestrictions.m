//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPDataRestrictions.h"

@implementation OPDataRestrictions

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.validators = [[OPValidators alloc] init];
    }
    return self;
}

@end
