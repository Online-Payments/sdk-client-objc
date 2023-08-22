//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <Foundation/Foundation.h>

#import "OPUtil.h"

__deprecated_msg("In a future release, this interface and its functions will become internal to the SDK.")
@interface OPC2SCommunicatorConfiguration : NSObject {
    NSString *_baseURL;
}

@property (strong, nonatomic) NSString *clientSessionId;
@property (strong, nonatomic) NSString *customerId;

@property (nonatomic, strong) NSString *appIdentifier;
@property (nonatomic, strong) NSString *ipAddress;

@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSString *assetsBaseURL;

@property (nonatomic) BOOL loggingEnabled;

- (instancetype)initWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId baseURL:(NSString *)baseURL assetBaseURL:(NSString *)assetBaseURL appIdentifier:(NSString *)appIdentifier util:(OPUtil *)util DEPRECATED_ATTRIBUTE __deprecated_msg("Please use initWithClientSessionId:customerId:baseURL:assetBaseURL:appIdentifier:util:loggingEnabled instead");
- (instancetype)initWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId baseURL:(NSString *)baseURL assetBaseURL:(NSString *)assetBaseURL appIdentifier:(NSString *)appIdentifier util:(OPUtil *)util loggingEnabled:(BOOL)loggingEnabled;
- (instancetype)initWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId baseURL:(NSString *)baseURL assetBaseURL:(NSString *)assetBaseURL appIdentifier:(NSString *)appIdentifier ipAddress:(NSString *)ipAddress util:(OPUtil *)util DEPRECATED_ATTRIBUTE __deprecated_msg("Please use initWithClientSessionId:customerId:baseURL:assetBaseURL:appIdentifier:ipAddress:util:loggingEnabled instead");
- (instancetype)initWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId baseURL:(NSString *)baseURL assetBaseURL:(NSString *)assetBaseURL appIdentifier:(NSString *)appIdentifier ipAddress:(NSString *)ipAddress util:(OPUtil *)util loggingEnabled:(BOOL)loggingEnabled;
- (NSString *)base64EncodedClientMetaInfo;

@end
