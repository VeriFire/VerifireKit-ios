//
//  NSObject+VFKeyValueCoding.m
//  Verifire
//
//  Created by Sergey P on 25.08.17.
//  Copyright © 2017 verifire.io. All rights reserved.
//

#import "NSObject+VFKeyValueCoding.h"

@implementation NSObject (VFKeyValueCoding)

- (NSString *)stringForKeyPath:(id)key
{
    NSString *string = nil;
    @try
    {
        id object = [self valueForKeyPath:key];
        if (object && [object isKindOfClass:[NSString class]])
        {
            string = object;
        }
    }
    @catch (__unused NSException *exception)
    {
        // Unused
    }
    @finally
    {
        return string;
    }
}

- (NSNumber *)numberForKeyPath:(id)key
{
    NSNumber *number = nil;
    @try
    {
        number = [self valueForKeyPath:key];
        if (number && [number isKindOfClass:[NSNumber class]])
        {
            return number;
        }
    }
    @catch (__unused NSException *exception)
    {
        // Unused
    }
    @finally
    {
        return number;
    }
}

@end
