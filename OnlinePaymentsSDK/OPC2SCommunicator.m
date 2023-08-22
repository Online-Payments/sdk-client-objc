//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPC2SCommunicator.h"
#import "OPBasicPaymentProductsConverter.h"
#import "OPPaymentProductConverter.h"
#import "OPNetworkingWrapper.h"
#import "OPPaymentAmountOfMoney.h"
#import "OPPaymentContextConverter.h"
#import "OPIINDetailsResponseConverter.h"
#import "OPSDKConstants.h"
#import <PassKit/PKPaymentAuthorizationViewController.h>

@interface OPC2SCommunicator ()

@property (strong, nonatomic) OPC2SCommunicatorConfiguration *configuration;
@property (strong, nonatomic) OPNetworkingWrapper *networkingWrapper;

@end

@implementation OPC2SCommunicator

- (instancetype)initWithConfiguration:(OPC2SCommunicatorConfiguration *)configuration
{
    self = [super init];
    if (self != nil) {
        self.configuration = configuration;
        self.networkingWrapper = [[OPNetworkingWrapper alloc] init];
    }
    return self;
}

- (void)paymentProductsForContext:(OPPaymentContext *)context success:(void (^)(OPBasicPaymentProducts *paymentProducts))success failure:(void (^)(NSError *error))failure
{
    NSString *isRecurring = context.isRecurring == YES ? @"true" : @"false";
    NSString *URL = [NSString stringWithFormat:@"%@/%@/products?countryCode=%@&locale=%@&currencyCode=%@&amount=%lu&hide=fields&isRecurring=%@", [self baseURL], self.configuration.customerId, context.countryCode, context.locale, context.amountOfMoney.currencyCode, (unsigned long)context.amountOfMoney.totalAmount, isRecurring];
    [self getResponseForURL:URL success:^(id responseObject) {
        NSArray *rawPaymentProducts = [(NSDictionary *)responseObject objectForKey:@"paymentProducts"];
        OPBasicPaymentProductsConverter *converter = [[OPBasicPaymentProductsConverter alloc] init];
        OPBasicPaymentProducts *paymentProducts = [converter paymentProductsFromJSON:rawPaymentProducts];
        [self checkApplePayAvailabilityWithPaymentProducts:paymentProducts forContext:context success:^{
            [self removeGooglePayProduct:paymentProducts];
            success(paymentProducts);
        } failure:^(NSError *error) {
            failure(error);
        }];
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)checkApplePayAvailabilityWithPaymentProducts:(OPBasicPaymentProducts *)paymentProducts forContext:(OPPaymentContext *)context success:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    OPBasicPaymentProduct *applePayPaymentProduct = [paymentProducts paymentProductWithIdentifier:kOPApplePayIdentifier];
    if (applePayPaymentProduct != nil) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") && [PKPaymentAuthorizationViewController canMakePayments]) {
            [self paymentProductNetworksForProductId:kOPApplePayIdentifier context:context success:^(OPPaymentProductNetworks *paymentProductNetworks) {
                if ([PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:paymentProductNetworks.paymentProductNetworks] == NO) {
                    [paymentProducts.paymentProducts removeObject:applePayPaymentProduct];
                }
                success();
            } failure:^(NSError *error) {
                failure(error);
            }];
        } else {
            [paymentProducts.paymentProducts removeObject:applePayPaymentProduct];
            success();
        }
    } else {
        success();
    }
}

- (void)removeGooglePayProduct:(OPBasicPaymentProducts *)paymentProducts {
    OPBasicPaymentProduct *googlePayPaymentProduct = [paymentProducts paymentProductWithIdentifier:kOPGooglePayIdentifier];
    if (googlePayPaymentProduct != nil) {
        [paymentProducts.paymentProducts removeObject:googlePayPaymentProduct];
    }
}

- (void)paymentProductNetworksForProductId:(NSString *)paymentProductId context:(OPPaymentContext *)context success:(void (^)(OPPaymentProductNetworks *paymentProductNetworks))success failure:(void (^)(NSError *error))failure {
    NSString *isRecurring = context.isRecurring == YES ? @"true" : @"false";
    NSString *URL = [NSString stringWithFormat:@"%@/%@/products/%@/networks?countryCode=%@&locale=%@&currencyCode=%@&amount=%lu&hide=fields&isRecurring=%@", [self baseURL], self.configuration.customerId, paymentProductId, context.countryCode, context.locale, context.amountOfMoney.currencyCode, (unsigned long)context.amountOfMoney.totalAmount, isRecurring];
    [self getResponseForURL:URL success:^(id responseObject) {
        NSArray *rawProductNetworks = [(NSDictionary *)responseObject objectForKey:@"networks"];
        OPPaymentProductNetworks *paymentProductNetworks = [[OPPaymentProductNetworks alloc] init];
        [paymentProductNetworks.paymentProductNetworks addObjectsFromArray:rawProductNetworks];
        success(paymentProductNetworks);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)paymentProductWithId:(NSString *)paymentProductId context:(OPPaymentContext *)context success:(void (^)(OPPaymentProduct *paymentProduct))success failure:(void (^)(NSError *error))failure
{
    [self checkAvailabilityForPaymentProductWithId:paymentProductId context:context success:^{
        NSString *isRecurring = context.isRecurring == YES ? @"true" : @"false";
        NSString *URL = [NSString stringWithFormat:@"%@/%@/products/%@/?countryCode=%@&locale=%@&currencyCode=%@&amount=%lu&isRecurring=%@", [self baseURL], self.configuration.customerId, paymentProductId, context.countryCode, context.locale, context.amountOfMoney.currencyCode, (unsigned long)context.amountOfMoney.totalAmount, isRecurring];
        [self getResponseForURL:URL success:^(id responseObject) {
            NSDictionary *rawPaymentProduct = (NSDictionary *)responseObject;
            OPPaymentProductConverter *converter = [[OPPaymentProductConverter alloc] init];
            OPPaymentProduct *paymentProduct = [converter paymentProductFromJSON:rawPaymentProduct];

            [self fixProductParametersIfRequired:paymentProduct];

            success(paymentProduct);
        } failure:^(NSError *error) {
            failure(error);
        }];
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)fixProductParametersIfRequired:(NSObject<OPPaymentItem> *)paymentProduct
{
    NSString *EXPIRY_DATE_MASK = @"{{99}}/{{99}}";
    NSString *REGULAR_CARD_NUMBER_MASK = @"{{9999}} {{9999}} {{9999}} {{9999}}";
    NSString *AMEX_CARD_NUMBER_MASK = @"{{9999}} {{999999}} {{99999}}";
    NSString *AMEX_PRODUCT_ID = @"2";
    NSString *EXPIRY_DATE_FIELD_ID = @"expiryDate";
    NSString *CARD_NUMBER_FIELD_ID = @"cardNumber";

    for (OPPaymentProductField* paymentProductField in paymentProduct.fields.paymentProductFields) {
        NSString *fieldId = paymentProductField.identifier;
        if (![fieldId isEqualToString: EXPIRY_DATE_FIELD_ID] && ![fieldId isEqualToString: CARD_NUMBER_FIELD_ID]) {
            continue;
        }

        if ([fieldId isEqualToString:EXPIRY_DATE_FIELD_ID]) {
            // Fix the field type
            if (paymentProductField.displayHints.formElement.type == OPListType) {
                paymentProductField.displayHints.formElement.type = OPTextType;
            }

            // Add the field mask
            if ([paymentProductField.displayHints.mask length] == 0) {
                paymentProductField.displayHints.mask = EXPIRY_DATE_MASK;
            }
        }

        if ([fieldId isEqualToString:CARD_NUMBER_FIELD_ID] && [paymentProductField.displayHints.mask length] == 0) {
            if ([paymentProduct.identifier isEqualToString:AMEX_PRODUCT_ID]) {
                paymentProductField.displayHints.mask = AMEX_CARD_NUMBER_MASK;
            } else {
                paymentProductField.displayHints.mask = REGULAR_CARD_NUMBER_MASK;
            }
        }
    }
}

- (void)checkAvailabilityForPaymentProductWithId:(NSString *)paymentProductId context:(OPPaymentContext *)context success:(void (^)(void))success failure:(void (^)(NSError *error))failure
{
    if ([paymentProductId isEqualToString:kOPApplePayIdentifier]) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") && [PKPaymentAuthorizationViewController canMakePayments]) {
            [self paymentProductNetworksForProductId:kOPApplePayIdentifier context:context success:^(OPPaymentProductNetworks *paymentProductNetworks) {
                if ([PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:paymentProductNetworks.paymentProductNetworks] == NO) {
                    failure([self badRequestErrorForPaymentProductId:paymentProductId context:context]);
                } else {
                    success();
                }
            } failure:^(NSError *error) {
                failure(error);
            }];
        } else {
            failure([self badRequestErrorForPaymentProductId:paymentProductId context:context]);
        }
    } else {
        success();
    }
}

- (NSError *)badRequestErrorForPaymentProductId:(NSString *)paymentProductId context:(OPPaymentContext *)context {
    
    NSString *isRecurring = context.isRecurring == YES ? @"true" : @"false";
    NSString *URL = [NSString stringWithFormat:@"%@/%@/products/%@/?countryCode=%@&locale=%@&currencyCode=%@&amount=%lu&isRecurring=%@", [self baseURL], self.configuration.customerId, paymentProductId, context.countryCode, context.locale, context.amountOfMoney.currencyCode, (unsigned long)context.amountOfMoney.totalAmount, isRecurring];
    NSDictionary *errorUserInfo = @{@"com.alamofire.serialization.response.error.response": [[NSHTTPURLResponse alloc] initWithURL:[NSURL fileURLWithPath:URL] statusCode:400 HTTPVersion:nil headerFields:@{@"Connection": @"close"}],
                                    @"NSErrorFailingURLKey": URL,
                                    @"com.alamofire.serialization.response.error.data": [NSData data],
                                    @"NSLocalizedDescription": @"Request failed: bad request (400)"};
    NSError *error = [NSError errorWithDomain:@"com.alamofire.serialization.response.error.response" code:-1011 userInfo:errorUserInfo];
    return error;
}

- (void)publicKeyWithSuccess:(void (^)(OPPublicKeyResponse *publicKeyResponse))success failure:(void (^)(NSError *error))failure
{
    NSString *URL = [NSString stringWithFormat:@"%@/%@/crypto/publickey", [self baseURL], self.configuration.customerId];
    [self getResponseForURL:URL success:^(id responseObject) {
        NSDictionary *rawPublicKeyResponse = (NSDictionary *)responseObject;
        NSString *keyId = [rawPublicKeyResponse objectForKey:@"keyId"];
        NSString *encodedPublicKey = [rawPublicKeyResponse objectForKey:@"publicKey"];
        OPPublicKeyResponse *response = [[OPPublicKeyResponse alloc] initWithKeyId:keyId encodedPublicKey:encodedPublicKey];
        success(response);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)paymentProductIdByPartialCreditCardNumber:(NSString *)partialCreditCardNumber context:(OPPaymentContext *)context success:(void (^)(OPIINDetailsResponse *iinDetailsResponse))success failure:(void (^)(NSError *error))failure {
    NSString *URL = [NSString stringWithFormat:@"%@/%@/services/getIINdetails", [self baseURL], self.configuration.customerId];
    
    NSString *trimmedPartialCreditCardNumber = [self getIINDigitsFrom:partialCreditCardNumber];
    
    NSDictionary *parameters;
    OPPaymentContextConverter *converter = [[OPPaymentContextConverter alloc] init];
    if (context == nil) {
        parameters = [converter JSONFromPartialCreditCardNumber:trimmedPartialCreditCardNumber];
    }
    else {
        parameters = [converter JSONFromPaymentProductContext:context partialCreditCardNumber:trimmedPartialCreditCardNumber];
    }
    
    NSMutableIndexSet *additionalAcceptableStatusCodes = [[NSMutableIndexSet alloc] initWithIndex:404];
    
    [self postResponseForURL:URL withParameters:parameters additionalAcceptableStatusCodes:additionalAcceptableStatusCodes success:^(id responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        OPIINDetailsResponseConverter *converter = [[OPIINDetailsResponseConverter alloc] init];
        OPIINDetailsResponse *IINDetails = [converter IINDetailsResponseFromJSON:response];
        success(IINDetails);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (NSString *)getIINDigitsFrom:(NSString *)partialCreditCardNumber {
    int max;
    if (partialCreditCardNumber.length >= 8) {
        max = 8;
    }
    else {
        max = (int) MIN(partialCreditCardNumber.length, 6);
    }
    return [partialCreditCardNumber substringToIndex:max];
}

- (NSDictionary *)headers
{
    NSDictionary *headers = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"GCS v1Client:%@", self.clientSessionId], @"Authorization", self.base64EncodedClientMetaInfo, @"X-GCS-ClientMetaInfo", nil];
    return headers;
}

- (void)getResponseForURL:(NSString *)URL success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    if([self loggingEnabled]) {
        [self logRequestForURL:URL forRequestMethod:@"GET" withParameters:[NSDictionary alloc]];
    }

    [self.networkingWrapper
     getResponseForURL:URL
     headers:[self headers]
     additionalAcceptableStatusCodes:nil
     success:^(id responseObject) {
        if([self loggingEnabled]) {
            [self logSuccessResponseForURL:URL forResponseObject:responseObject];
        }

        success(responseObject);
     }
     failure:^(NSError *error) {
        if([self loggingEnabled]) {
            [self logResponseForURL:URL forResponseCode:[NSNumber numberWithInteger: error.code] forResponseBody:[error localizedDescription] hasError:YES];
        }
        failure(error);
     }
    ];
}

- (void)postResponseForURL:(NSString *)URL withParameters:(NSDictionary *)parameters additionalAcceptableStatusCodes:(NSIndexSet *)additionalAcceptableStatusCodes success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    if([self loggingEnabled]) {
        [self logRequestForURL:URL forRequestMethod:@"POST" withParameters:parameters];
    }
    [self.networkingWrapper
     postResponseForURL:URL
     headers:[self headers]
     withParameters:parameters
     additionalAcceptableStatusCodes:additionalAcceptableStatusCodes
     success:^(id responseObject) {
        if([self loggingEnabled]) {
            [self logSuccessResponseForURL:URL forResponseObject:responseObject];
        }

        success(responseObject);
     }
     failure:^(NSError *error) {
        if([self loggingEnabled]) {
            [self logResponseForURL:URL forResponseCode:[NSNumber numberWithInteger: error.code] forResponseBody:[error localizedDescription] hasError:YES];
        }
        failure(error);
     }
    ];
}

- (NSString *)baseURL
{
    return [self.configuration baseURL];
}

-(void)setBaseURL:(NSString *)baseURL {
    [self.configuration setBaseURL:baseURL];
}

-(void)setAssetsBaseURL:(NSString *)assetsBaseURL {
    [self.configuration setAssetsBaseURL:assetsBaseURL];
}

- (NSString *)assetsBaseURL
{
    return [self.configuration assetsBaseURL];
}

-(void)setLoggingEnabled:(BOOL)loggingEnabled {
    [self.configuration setLoggingEnabled:loggingEnabled];
}

- (BOOL)loggingEnabled {
    return [self.configuration loggingEnabled];
}

- (NSString *)base64EncodedClientMetaInfo
{
    return [self.configuration base64EncodedClientMetaInfo];
}

- (NSString *)clientSessionId
{
    return [self.configuration clientSessionId];
}

-(void)logSuccessResponseForURL:(NSString *)URL forResponseObject:(id)responseObject {
    NSNumber *responseCode = responseObject[@"statusCode"];

    [responseObject removeObjectForKey:@"statusCode"];

    [self logResponseForURL:URL forResponseCode:responseCode forResponseBody:responseObject hasError:NO];
}

/**
 * Logs all request headers, url and body
 */
-(void)logRequestForURL:(NSString *)URL forRequestMethod:(NSString *)requestMethod withParameters:(NSDictionary *)parameters {
    NSString* requestLog = [NSString stringWithFormat:
    @"Request URL : %@ \n"
    "Request Method: %@ \n"
    "Request Headers : %@ \n",
    URL, requestMethod, self.headers
    ];

    if([requestMethod isEqual: @"POST"]) {
        requestLog = [requestLog stringByAppendingString:[NSString stringWithFormat: @"Body: %@", parameters]];
    }

    NSLog(@"%@", requestLog);
}

/**
 * Logs all response headers, status code and body
 */
-(void)logResponseForURL:(NSString *)URL forResponseCode:(NSNumber *)responseCode forResponseBody:(NSString *)responseBody hasError:(BOOL)hasError {
    NSString* responseLog = [NSString stringWithFormat:
    @"Response URL : %@ \n"
    "Response Code : %@ \n"
    "Response Headers : %@ \n",
    URL, responseCode, self.headers];

    if(hasError) {
        responseLog = [responseLog stringByAppendingString:@"Response Error : "];
    } else {
        responseLog = [responseLog stringByAppendingString:@"Response Body : "];
    }

    responseLog = [responseLog stringByAppendingString:[NSString stringWithFormat: @"%@", responseBody]];

    NSLog(@"%@", responseLog);
}

@end
