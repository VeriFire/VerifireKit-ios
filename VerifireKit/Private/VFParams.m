//
//  VFParams.m
//  Verifire
//
//  Created by Sergey P on 22.08.17.
//  Copyright © 2017 verifire.io. All rights reserved.
//

#import "VFParams_Private.h"
#import "VFMacros.h"

// Methods
#import "VFVerifire.h"

@implementation VFParams

#pragma mark - Properties

- (void)setMethod:(NSString *)method
{
    NSSet *methodsToValidate = [NSSet setWithObjects:VFVerifireMethodSMS, VFVerifireMethodCall, VFVerifireMethodVoice, nil];
    if ([methodsToValidate containsObject:method])
    {
        _method = method;
    }
    else
    {
        @throw [NSException exceptionWithName:NSGenericException reason:@"Invalid method" userInfo:nil];
    }
}

#pragma mark - Lifecycle

- (instancetype)initWithMethod:(NSString *)method phoneNumber:(NSString *)phoneNumber
{
    NSParameterAssert(method);
    NSParameterAssert(phoneNumber);
    
    self = [super init];
    if (self)
    {
        // Set method
        self.method = method;
        
        _phoneNumber = phoneNumber;
        
        // Set sender id as app name
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        _senderId = infoDictionary[(__bridge NSString *)kCFBundleExecutableKey] ?: infoDictionary[(__bridge NSString *)kCFBundleIdentifierKey];
        
        // Set language because we using param `Accepted-Language` in the header
        _language = nil;
        
        // Set default code lenght
        _codeLength = @(VF_PARAMS_DEFAULT_CODE_LENGTH);
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    VFParams *copy = [[[self class] allocWithZone:zone] init];
    if (copy)
    {
        copy.requestId = [self.requestId copy];
        copy.method = [self.method copy];
        copy.senderId = [self.senderId copy];
        copy.language = [self.senderId copy];
        copy->_phoneNumber = [self.phoneNumber copy];
        copy.codeLength = [self.codeLength copy];
    }
    return copy;
}

@end
