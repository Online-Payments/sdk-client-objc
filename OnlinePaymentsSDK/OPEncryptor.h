//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <Foundation/Foundation.h>

__deprecated_msg("In a future release, this interface and its functions will become internal to the SDK.")
@interface OPEncryptor : NSObject

- (void)generateRSAKeyPairWithPublicTag:(NSString *)publicTagString privateTag:(NSString *)privateTagString;
- (void)storeRSAKeyPairFromPFXData:(NSData *)PFXData password:(NSString *)password publicTag:(NSString *)publicTag privateTag:(NSString *)privateTag;
- (NSData *)stripPublicKey:(NSData *)DERData;
- (void)storePublicKey:(NSData *)DERData tag:(NSString *)tag;

- (NSData *)generateRandomBytesWithLength:(size_t)length;

- (NSData *)encryptRSA:(NSData *)plaintext key:(SecKeyRef)publicKey;
- (NSData *)decryptRSA:(NSData *)cipher key:(SecKeyRef)privateKey;
- (SecKeyRef)RSAKeyWithTag:(NSString*)keyIdentifier;
- (void)deleteRSAKeyWithTag:(NSString *)tag;

- (NSData *)encryptAES:(NSData *)plaintext key:(NSData *)key IV:(NSData *)IV;
- (NSData *)decryptAES:(NSData *)ciphertext key:(NSData *)key IV:(NSData *)IV;

- (NSData *)generateHMAC:(NSData *)input key:(NSData *)key;

- (NSString *)UUID;


@end
