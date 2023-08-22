//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "OPEncryptor.h"

__deprecated_msg("In a future release, this interface and its functions will become internal to the SDK.")
@interface OPJOSEEncryptor : NSObject

- (instancetype)initWithEncryptor:(OPEncryptor *)encryptor;
- (NSString *)encryptToCompactSerialization:(NSString *)JSON withPublicKey:(SecKeyRef)publicKey keyId:(NSString *)keyId;
- (NSString *)decryptFromCompactSerialization:(NSString *)JOSE withPrivateKey:(SecKeyRef)privateKey;

@end
