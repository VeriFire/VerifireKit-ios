//
//  VFParams.h
//  Verifire
//
//  Created by Sergey P on 22.08.17.
//  Copyright © 2017 verifire.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VFParams : NSObject <NSCopying>

- (instancetype)init NS_UNAVAILABLE;

@property (strong, nonatomic, readonly) NSString *method;
@property (strong, nonatomic, readonly) NSString *phoneNumber;

@property (strong, nonatomic) NSString *senderId;
@property (strong, nonatomic) NSString *language;
@property (strong, nonatomic) NSNumber *codeLength;

- (instancetype)initWithMethod:(NSString *)method phoneNumber:(NSString *)phoneNumber NS_DESIGNATED_INITIALIZER;

@end
