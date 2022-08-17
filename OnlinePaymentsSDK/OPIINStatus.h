//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#ifndef OnlinePaymentsSDKExample_OPIINStatus_h
#define OnlinePaymentsSDKExample_OPIINStatus_h

typedef enum {
    OPSupported,
    OPUnsupported DEPRECATED_ATTRIBUTE __deprecated_msg("In a next release, this status will be removed."),
    OPUnknown,
    OPNotEnoughDigits,
    OPPending DEPRECATED_ATTRIBUTE __deprecated_msg("In a next release, this status will be removed."),
    OPExistingButNotAllowed
} OPIINStatus;

#endif
