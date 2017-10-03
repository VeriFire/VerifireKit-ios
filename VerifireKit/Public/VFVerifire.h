//
//  VFVerifire.h
//  Verifire
//
//  Created by Sergey P on 15.08.17.
//  Copyright © 2017 verifire.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFVerifire : NSObject

- (nullable instancetype)init NS_UNAVAILABLE;
+ (nullable instancetype)new NS_UNAVAILABLE;

/*!
 * Default method to init SDK
 * @param key is a requered developer key. More info on https://verifire.io/
 */
- (nullable instancetype)initWithKey:(nonnull NSString *)key;

/*!
 * To begin phone number verification call the methdo with phone number and method.
 * @param phoneNumber is a valid phone number in internation E164 format example: +1234567890
 * @param method one of the requered methods `sms`, `call`, `voice`
 * @param callback is a block to handle the result of requested verification. If the `error` is nil verification request succeeded.
 */
- (void)verifyNumber:(nonnull NSString *)phoneNumber method:(nonnull NSString *)method
          completion:(nonnull void (^)(NSError *_Nullable error))callback;

/*!
 * To complete the verification call the method with a PIN `code`. And receive reuslt of the verification.
 * @param code - is a PIN code send by chosen method earlier. In case `call` it 4 last digits CLI of the incomming call.
 * @param callback - is handling the result of verification, if `error` is nil the verification was successfully completed and phone number is verified.
 * `requestId` is a unique id of the current verification it can be used to check the number on a backend REST method `/verify/info` more on https://verifire.io/
 */
- (void)confirmWithCode:(nonnull NSString *)code
             completion:(nonnull void (^)(NSString *_Nullable phoneNumber, NSString *_Nullable requestId, NSError *_Nullable error))callback;

@end

extern NSString *_Nonnull const VFVerifireMethodSMS;
extern NSString *_Nonnull const VFVerifireMethodCall;
extern NSString *_Nonnull const VFVerifireMethodVoice;

typedef enum : NSUInteger
{
    VFVerifireErrorUnkonwn = 0,
    VFVerifireErrorInvalidCode,
    VFVerifireErrorInvalidPhoneNumber,
}
VFVerifireError;

extern NSString *_Nonnull const VFVerifireErrorDomain;
