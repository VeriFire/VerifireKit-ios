//
//  VFVerifire.m
//  Verifire
//
//  Created by Sergey P on 15.08.17.
//  Copyright © 2017 verifire.io. All rights reserved.
//

#import "VFVerifire_Private.h"

#import "VFMacros.h"
#import "VFRequestCenter.h"
#import "VFParams_Private.h"

@implementation VFVerifire

#pragma mark - Lifecycle

- (instancetype)initWithKey:(NSString *)key
{
    NSMutableArray *strings = [[key componentsSeparatedByString:@":"] mutableCopy];
    
    NSAssert(strings.count == 3, @"Invalid key");
    
    NSString *privateKey = strings.lastObject;
    
    [strings removeObject:privateKey];
    
    NSString *publicKey = [strings componentsJoinedByString:@":"];
    
    VFRequestCenter *center = [[VFRequestCenter alloc] initWithPublicKey:publicKey privateKey:privateKey];
    
    return [self initWithRequestCenter:center];
}

- (instancetype)initWithRequestCenter:(VFRequestCenter *)center
{
    self = [super init];
    if (self)
    {
        _requestCenter = center;
    }
    return self;
}

#pragma mark - Public

- (void)verifyNumber:(NSString *)phoneNumber method:(NSString *)method completion:(void (^)(NSError * _Nullable))callback
{
    NSParameterAssert(phoneNumber);
    NSParameterAssert(method);
    NSParameterAssert(callback);
    
    VFParams *params = [[VFParams alloc] initWithMethod:method phoneNumber:phoneNumber];
    
    [self.requestCenter verifyWithParams:params completion:^(NSString * _Nullable requestId, NSError * _Nullable error) {
        
        // Set request Id
        self.requestId = requestId;
        
        callback(error);
    }];
}

- (void)confirmWithCode:(NSString *)code completion:(void (^)(NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))callback
{
    NSParameterAssert(code);
    NSParameterAssert(callback);
    
    [self.requestCenter confirmWithCode:code requestId:self.requestId completion:^(VFParams * _Nullable response, NSError * _Nullable error) {
        
        callback(response.phoneNumber, response.requestId, TransformError(error));
    }];
}

#pragma mark - Functions

static NSError * TransformError(NSError *error)
{
    switch (error.code)
    {
        case 21:
        {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey : VFLocalizedString(@"Invalid verification code", nil)};
            return [NSError errorWithDomain:VFVerifireErrorDomain code:VFVerifireErrorInvalidCode userInfo:userInfo];
        }
            
        default:
            return error;
    }
}

@end

NSString * _Nonnull const VFVerifireMethodSMS = @"sms";
NSString * _Nonnull const VFVerifireMethodCall = @"call";
NSString * _Nonnull const VFVerifireMethodVoice = @"voice";

NSString *_Nonnull const VFVerifireErrorDomain = @"VFVerifireErrorDomain";
