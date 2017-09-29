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

- (nullable instancetype)initWithKey:(nonnull NSString *)key;

- (void)verifyNumber:(nonnull NSString *)phoneNumber method:(nonnull NSString *)method
          completion:(nonnull void (^)(NSError *_Nullable error))callback;

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
