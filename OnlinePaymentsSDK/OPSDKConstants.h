//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#ifndef OnlinePaymentsSDK_OPSDKConstants_h
#define OnlinePaymentsSDK_OPSDKConstants_h
#import  "OPSession.h"

//Keys
#define kOPSDKLocalizable           @"OPSDKLocalizable"
#define kOPImageMapping             @"kOPImageMapping"
#define kOPImageMappingInitialized  @"kOPImageMappingInitialized"
#define kOPIINMapping               @"kOPIINMapping"
#define kOPSDKBundlePath            [[NSBundle bundleForClass:[OPSession class]] pathForResource:@"OnlinePaymentsSDK" ofType:@"bundle"]
#define kOPAPIVersion               @"client/v1"

#define StandardUserDefaults        [NSUserDefaults standardUserDefaults]
#define DocumentsFolderPath         [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define kOPApplePayIdentifier       @"302"
#define kOPGooglePayIdentifier       @"320"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#endif

