//
//  VFRequestCenter.h
//  Verifire
//
//  Created by Sergey P on 15.08.17.
//
//

#import <Foundation/Foundation.h>

@class VFParams, VFSession;

@interface VFRequestCenter : NSObject

+ (nullable instancetype)new NS_UNAVAILABLE;
- (nullable instancetype)init NS_UNAVAILABLE;

- (nullable instancetype)initWithPublicKey:(nonnull NSString *)publicKey
                                privateKey:(nonnull NSString *)privateKey;

- (nullable instancetype)initWithSession:(nonnull VFSession *)session NS_DESIGNATED_INITIALIZER;

- (void)verifyWithParams:(nonnull VFParams *)params
              completion:(nonnull void(^)(NSString *_Nullable requestId, NSError *_Nullable error))callback;

- (void)confirmWithCode:(nonnull NSString *)code requestId:(nonnull NSString *)requestId
             completion:(nonnull void(^)(VFParams *_Nullable response, NSError *_Nullable error))callback;

@end
