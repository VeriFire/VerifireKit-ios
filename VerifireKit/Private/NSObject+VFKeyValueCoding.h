//
//  NSObject+VFKeyValueCoding.h
//  Verifire
//
//  Created by Sergey P on 25.08.17.
//  Copyright © 2017 verifire.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (VFKeyValueCoding)

- (nullable NSString *)stringForKeyPath:(nonnull id)key;
- (nullable NSNumber *)numberForKeyPath:(nonnull id)key;

@end
