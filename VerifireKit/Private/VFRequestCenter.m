//
//  VFRequestCenter.m
//  Verifire
//
//  Created by Sergey P on 15.08.17.
//
//

#import "VFRequestCenter.h"

#import "VFMacros.h"
#import "VFSession.h"
#import "VFParams_Private.h"
#import "VFRequestSerializer.h"
#import "VFResponseSerializer.h"
#import "NSObject+VFKeyValueCoding.h"

@interface VFRequestCenter ()

@property (strong, nonatomic, readonly) VFSession *session;

@end

@implementation VFRequestCenter

#pragma mark - Lifecycle

- (instancetype)initWithPublicKey:(NSString *)publicKey privateKey:(NSString *)privateKey
{
    NSURL *baseURL = [NSURL URLWithString:VF_BASE_API_URL];
    
    VFSession *session = [[VFSession alloc] initWithBaseURL:baseURL];
    
    session.requestSerializer = [[VFRequestSerializer alloc] initWithPublicKey:publicKey privateKey:privateKey];
    session.responseSerializer = [[VFResponseSerializer alloc] init];
    
    return [self initWithSession:session];
}

- (instancetype)initWithSession:(VFSession *)session
{
    NSParameterAssert(session);
    self = [super init];
    if (self)
    {
        _session = session;
    }
    return self;
}

#pragma mark - Public Methods

- (void)verifyWithParams:(VFParams *)params completion:(void (^)(NSString * _Nullable, NSError * _Nullable))callback
{
    NSParameterAssert(params);
    NSParameterAssert(callback);
    
    NSMutableDictionary *_params = [[NSMutableDictionary alloc] init];
    [_params setValue:params.method forKey:@"method"];
    [_params setValue:params.phoneNumber forKey:@"number"];
    [_params setValue:params.language forKey:@"language"];
    
    [self.session POST:@"/v1/verify" parameters:_params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError *error = nil;
        NSString *requestId = [responseObject stringForKeyPath:@"requestId"];
        
        callback(requestId, error);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        callback(nil, error);
        
    }];
}

- (void)confirmWithCode:(NSString *)code requestId:(NSString *)requestId completion:(void (^)(VFParams * _Nullable, NSError * _Nullable))callback
{
    NSParameterAssert(code);
    NSParameterAssert(requestId);
    NSParameterAssert(callback);
    
    NSDictionary *params = @{
        @"requestId" : requestId,
        @"code" : code
    };
    
    [self.session POST:@"/v1/verify/check" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *method = [responseObject stringForKeyPath:@"method"];
        NSString *phoneNumber = [responseObject stringForKeyPath:@"number"];
        
        VFParams *params = [[VFParams alloc] initWithMethod:method phoneNumber:phoneNumber];
        
        callback(params, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        callback(nil, error);
        
    }];
}

@end
