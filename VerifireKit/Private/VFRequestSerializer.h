//
//  VFRequestSerializer.h
//  Verifire
//
//  Created by Sergey P on 15.08.17.
//  Copyright © 2017 verifire.io. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface VFRequestSerializer : AFHTTPRequestSerializer

+ (nullable instancetype)new NS_UNAVAILABLE;
- (nullable instancetype)init NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *_Nonnull)aDecoder NS_UNAVAILABLE;
+ (nonnull instancetype)serializer NS_UNAVAILABLE;

@property (copy, nonatomic, nullable) NSString *userAgent;
@property (strong, nonatomic, nonnull, readonly) NSString *publicKey;
@property (strong, nonatomic, nonnull, readonly) NSString *privateKey;

- (nullable instancetype)initWithPublicKey:(nonnull NSString *)publicKey
                                privateKey:(nonnull NSString *)privateKey NS_DESIGNATED_INITIALIZER;

@end
