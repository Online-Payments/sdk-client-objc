//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPSession.h"
#import "OPBase64.h"
#import "OPJSON.h"
#import "OPSDKConstants.h"
#import "OPPaymentItems.h"
#import <PassKit/PassKit.h>

@interface OPSession ()

@property (strong, nonatomic) OPC2SCommunicator *communicator;
@property (strong, nonatomic) OPAssetManager *assetManager DEPRECATED_ATTRIBUTE __deprecated_msg("In a next release, this property will be removed. Instead retrieve logos / tooltip images by accessing the OPPaymentItem");
@property (strong, nonatomic) OPEncryptor *encryptor;
@property (strong, nonatomic) OPJOSEEncryptor *JOSEEncryptor;
@property (strong, nonatomic) OPStringFormatter *stringFormatter;
@property (strong, nonatomic) OPBasicPaymentProducts *paymentProducts;
@property (strong, nonatomic) NSMutableDictionary *paymentProductMapping;
@property (strong, nonatomic) OPBase64 *base64;
@property (strong, nonatomic) OPJSON *JSON;
@property (strong, nonatomic) NSMutableDictionary *IINMapping;
@property (assign, nonatomic) BOOL iinLookupPending;

@end

@implementation OPSession

- (instancetype)initWithCommunicator:(OPC2SCommunicator *)communicator assetManager:(OPAssetManager *)assetManager encryptor:(OPEncryptor *)encryptor JOSEEncryptor:(OPJOSEEncryptor *)JOSEEncryptor stringFormatter:(OPStringFormatter *)stringFormatter
{
    self = [super init];
    if (self != nil) {
        self.base64 = [[OPBase64 alloc] init];
        self.JSON = [[OPJSON alloc] init];
        self.communicator = communicator;
        self.assetManager = assetManager;
        self.encryptor = encryptor;
        self.JOSEEncryptor = JOSEEncryptor;
        self.stringFormatter = stringFormatter;
        self.IINMapping = [[StandardUserDefaults objectForKey:kOPIINMapping] mutableCopy];
        if (self.IINMapping == nil) {
            self.IINMapping = [[NSMutableDictionary alloc] init];
        }
        self.paymentProductMapping = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (instancetype)initWithCommunicator:(OPC2SCommunicator *)communicator encryptor:(OPEncryptor *)encryptor JOSEEncryptor:(OPJOSEEncryptor *)JOSEEncryptor stringFormatter:(OPStringFormatter *)stringFormatter
{
    self = [super init];
    if (self != nil) {
        self.base64 = [[OPBase64 alloc] init];
        self.JSON = [[OPJSON alloc] init];
        self.communicator = communicator;
        self.assetManager = nil;
        self.encryptor = encryptor;
        self.JOSEEncryptor = JOSEEncryptor;
        self.stringFormatter = stringFormatter;
        self.IINMapping = [[StandardUserDefaults objectForKey:kOPIINMapping] mutableCopy];
        if (self.IINMapping == nil) {
            self.IINMapping = [[NSMutableDictionary alloc] init];
        }
        self.paymentProductMapping = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(NSString *)baseURL {
    return [self.communicator baseURL];
}

-(NSString *)assetsBaseURL {
    return [self.communicator assetsBaseURL];
}

- (BOOL)loggingEnabled {
    return [self.communicator loggingEnabled];
}

-(void)setLoggingEnabled:(BOOL)loggingEnabled {
    [self.communicator setLoggingEnabled:loggingEnabled];
}

+ (OPSession *)sessionWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId baseURL:(NSString *)baseURL assetBaseURL:(NSString *)assetBaseURL appIdentifier:(NSString *)appIdentifier{
    OPUtil *util = [[OPUtil alloc] init];
    OPAssetManager *assetManager = [[OPAssetManager alloc] init];
    OPStringFormatter *stringFormatter = [[OPStringFormatter alloc] init];
    OPEncryptor *encryptor = [[OPEncryptor alloc] init];
    OPC2SCommunicatorConfiguration *configuration = [[OPC2SCommunicatorConfiguration alloc] initWithClientSessionId:clientSessionId customerId:customerId baseURL:baseURL assetBaseURL:assetBaseURL appIdentifier:appIdentifier util:util loggingEnabled:NO];
    OPC2SCommunicator *communicator = [[OPC2SCommunicator alloc] initWithConfiguration:configuration];
    OPJOSEEncryptor *JOSEEncryptor = [[OPJOSEEncryptor alloc] initWithEncryptor:encryptor];
    OPSession *session = [[OPSession alloc] initWithCommunicator:communicator assetManager:assetManager encryptor:encryptor JOSEEncryptor:JOSEEncryptor stringFormatter:stringFormatter];
    return session;
}

+ (OPSession *)sessionWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId baseURL:(NSString *)baseURL assetBaseURL:(NSString *)assetBaseURL appIdentifier:(NSString *)appIdentifier loggingEnabled:(BOOL)loggingEnabled {
    OPUtil *util = [[OPUtil alloc] init];
    OPAssetManager *assetManager = [[OPAssetManager alloc] init];
    OPStringFormatter *stringFormatter = [[OPStringFormatter alloc] init];
    OPEncryptor *encryptor = [[OPEncryptor alloc] init];
    OPC2SCommunicatorConfiguration *configuration = [[OPC2SCommunicatorConfiguration alloc] initWithClientSessionId:clientSessionId customerId:customerId baseURL:baseURL assetBaseURL:assetBaseURL appIdentifier:appIdentifier util:util loggingEnabled:loggingEnabled];
    OPC2SCommunicator *communicator = [[OPC2SCommunicator alloc] initWithConfiguration:configuration];
    OPJOSEEncryptor *JOSEEncryptor = [[OPJOSEEncryptor alloc] initWithEncryptor:encryptor];
    OPSession *session = [[OPSession alloc] initWithCommunicator:communicator encryptor:encryptor JOSEEncryptor:JOSEEncryptor stringFormatter:stringFormatter];
    return session;
}

- (void)paymentProductsForContext:(OPPaymentContext *)context success:(void (^)(OPBasicPaymentProducts *paymentProducts))success failure:(void (^)(NSError *error))failure
{
    [self.communicator paymentProductsForContext:context success:^(OPBasicPaymentProducts *paymentProducts) {
        self.paymentProducts = paymentProducts;
        self.paymentProducts.stringFormatter = self.stringFormatter;
        [self setLogoForPaymentItems:paymentProducts.paymentProducts completion:^{
            success(paymentProducts);
        }];
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)paymentProductNetworksForProductId:(NSString *)paymentProductId context:(OPPaymentContext *)context success:(void (^)(OPPaymentProductNetworks *paymentProductNetworks))success failure:(void (^)(NSError *error))failure {
    [self.communicator paymentProductNetworksForProductId:paymentProductId context:context success:^(OPPaymentProductNetworks *paymentProductNetworks) {
        success(paymentProductNetworks);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)paymentItemsForContext:(OPPaymentContext *)context groupPaymentProducts:(BOOL)groupPaymentProducts success:(void (^)(OPPaymentItems *paymentItems))success failure:(void (^)(NSError *error))failure {
    [self.communicator paymentProductsForContext:context success:^(OPBasicPaymentProducts *paymentProducts) {
        if (paymentProducts.paymentProducts.count == 0) {
            OPPaymentItems *items = [[OPPaymentItems alloc] initWithPaymentProducts:paymentProducts groups:nil];
            success(items);
        }
        self.paymentProducts = paymentProducts;
        self.paymentProducts.stringFormatter = self.stringFormatter;

        OPPaymentItems *items = [[OPPaymentItems alloc] initWithPaymentProducts:paymentProducts groups:nil];
        [self setLogoForPaymentItems:items.paymentItems completion:^{
            success(items);
        }];
    } failure:failure];
}

- (void)paymentProductWithId:(NSString *)paymentProductId context:(OPPaymentContext *)context success:(void (^)(OPPaymentProduct *paymentProduct))success failure:(void (^)(NSError *error))failure
{
    NSString *key = [NSString stringWithFormat:@"%@-%@", paymentProductId, [context description]];
    OPPaymentProduct *paymentProduct = [self.paymentProductMapping objectForKey:key];
    if (paymentProduct != nil) {
        success(paymentProduct);
    } else {
        [self.communicator paymentProductWithId:paymentProductId context:context success:^(OPPaymentProduct *paymentProduct) {
            [self.paymentProductMapping setObject:paymentProduct forKey:key];
            [self setTooltipImages:paymentProduct completion:^{}];
            [self setLogoForDisplayHints:paymentProduct.displayHints completion:^{}];
            [self setLogoForDisplayHintsList:paymentProduct.displayHintsList completion:^{
                success(paymentProduct);
            }];
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
}

- (void)IINDetailsForPartialCreditCardNumber:(NSString *)partialCreditCardNumber context:(OPPaymentContext *)context success:(void (^)(OPIINDetailsResponse *iinDetailsResponse))success failure:(void (^)(NSError *error))failure
{
    if (partialCreditCardNumber.length < 6) {
        OPIINDetailsResponse *response = [[OPIINDetailsResponse alloc] initWithStatus:OPNotEnoughDigits];
        success(response);
    } else {
        self.iinLookupPending = YES;
        [self.communicator paymentProductIdByPartialCreditCardNumber:partialCreditCardNumber context:context success:^(OPIINDetailsResponse *response) {
            self.iinLookupPending = NO;
            success(response);
        } failure:^(NSError *error) {
            self.iinLookupPending = NO;
            failure(error);
        }];
    }
}

- (void)preparePaymentRequest:(OPPaymentRequest *)paymentRequest success:(void (^)(OPPreparedPaymentRequest *preparedPaymentRequest))success failure:(void (^)(NSError *error))failure;
{
    [self.communicator publicKeyWithSuccess:^(OPPublicKeyResponse *publicKeyResponse) {
        NSString *keyId = publicKeyResponse.keyId;
        
        NSString *encodedPublicKey = publicKeyResponse.encodedPublicKey;
        NSData *publicKeyAsData = [self.base64 decode:encodedPublicKey];
        NSData *strippedPublicKeyAsData = [self.encryptor stripPublicKey:publicKeyAsData];
        NSString *tag = @"globalcollect-sdk-public-key";
        [self.encryptor deleteRSAKeyWithTag:tag];
        [self.encryptor storePublicKey:strippedPublicKeyAsData tag:tag];
        SecKeyRef publicKey = [self.encryptor RSAKeyWithTag:tag];
        
        OPPreparedPaymentRequest *preparedRequest = [[OPPreparedPaymentRequest alloc] init];
        NSMutableString *paymentRequestJSON = [[NSMutableString alloc] init];
        NSString *clientSessionId = [NSString stringWithFormat:@"{\"clientSessionId\": \"%@\", ", [self clientSessionId]];
        [paymentRequestJSON appendString:clientSessionId];
        NSString *nonce = [NSString stringWithFormat:@"\"nonce\": \"%@\", ", [self.encryptor UUID]];
        [paymentRequestJSON appendString:nonce];
        NSString *paymentProduct = [NSString stringWithFormat:@"\"paymentProductId\": %ld, ", (long)[paymentRequest.paymentProduct.identifier integerValue]];
        [paymentRequestJSON appendString:paymentProduct];
        if (paymentRequest.accountOnFile != nil) {
            NSString *accountOnFile = [NSString stringWithFormat:@"\"accountOnFileId\": %ld, ", (long)[paymentRequest.accountOnFile.identifier integerValue]];
            [paymentRequestJSON appendString:accountOnFile];
        }
        if (paymentRequest.tokenize == YES) {
            NSString *tokenize = @"\"tokenize\": true, ";
            [paymentRequestJSON appendString:tokenize];
        }
        NSString *paymentValues = [NSString stringWithFormat:@"\"paymentValues\": %@}", [self.JSON keyValueJSONFromDictionary:paymentRequest.unmaskedFieldValues]];
        [paymentRequestJSON appendString:paymentValues];
        preparedRequest.encryptedFields = [self.JOSEEncryptor encryptToCompactSerialization:paymentRequestJSON withPublicKey:publicKey keyId:keyId];
        preparedRequest.encodedClientMetaInfo = [self.communicator base64EncodedClientMetaInfo];
        success(preparedRequest);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)setLogoForPaymentItems:(NSArray *)paymentItems completion:(void(^)(void))completion;
{
    __block int counter = 0;
    for (OPBasicPaymentProduct *paymentItem in paymentItems) {
        [self setLogoForDisplayHints:paymentItem.displayHints completion:^{}];
        if (paymentItem.displayHintsList != nil) {
            [self setLogoForDisplayHintsList:paymentItem.displayHintsList completion:^{
                counter += 1;
                if (counter == [paymentItems count]) {
                    completion();
                }
            }];
        } else {
            counter += 1;
            if (counter == [paymentItems count]) {
                completion();
            }
        }
    }
}

- (void)setLogoForDisplayHints:(OPPaymentItemDisplayHints *)displayHints completion:(void(^)(void))completion;
{
    [self getLogoByStringURL:displayHints.logoPath callback:^(UIImage *image) {
        if (image != nil) {
            displayHints.logoImage = image;
        }
        completion();
    }];
}


- (void)setLogoForDisplayHintsList:(NSArray *)displayHints completion:(void(^)(void))completion;
{
    __block int counter = 0;
    for (OPPaymentItemDisplayHints *displayHint in displayHints)
        [self getLogoByStringURL:displayHint.logoPath callback:^(UIImage *image) {
            counter += 1;
            if (image != nil) {
                displayHint.logoImage = image;
            }
            if (counter == [displayHints count]) {
                completion();
            }
        }];
}

- (void)setTooltipImages:(NSObject<OPPaymentItem> *)paymentItem completion:(void(^)(void))completion;
{
    for (OPPaymentProductField *field in paymentItem.fields.paymentProductFields)
        if (field.displayHints.tooltip.imagePath != nil) {
            [self getLogoByStringURL:field.displayHints.tooltip.imagePath callback:^(UIImage *image) {
                field.displayHints.tooltip.image = image;
            }];
        }
}


- (NSString *)clientSessionId
{
    return [self.communicator clientSessionId];
}

- (void) getLogoByStringURL:(NSString *)url callback:(void (^)(UIImage *))callback
{
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSString *urlString = [url stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlString]];

        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData: data];
            callback(image);
        });
    });
}

@end
