//
//  VFVerifire_Private.h
//  Verifire
//
//  Created by Sergey P on 24.08.17.
//  Copyright © 2017 verifire.io. All rights reserved.
//

#import "VFVerifire.h"

@class VFRequestCenter;

@interface VFVerifire ()

@property (strong, nonatomic, nonnull, readonly) VFRequestCenter *requestCenter;
@property (strong, nonatomic, nullable) NSString *requestId;

@end
