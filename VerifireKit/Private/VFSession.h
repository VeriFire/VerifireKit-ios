//
//  VFSessionManager.h
//  Verifire
//
//  Created by Sergey P on 15.08.17.
//  Copyright © 2017 verifire.io. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface VFSession : AFHTTPSessionManager

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration NS_UNAVAILABLE;

@end
