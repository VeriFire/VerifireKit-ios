//
//  AppDelegate.m
//  VerifyExample
//
//  Created by Sergey P on 22.09.17.
//  Copyright © 2017 Sergey Popov. All rights reserved.
//

#import "AppDelegate.h"
#import <VerifireKit/VerifireKit.h>

#define VERIFIRE_KEY @"<# Your key #>"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _veriFire = [[VFVerifire alloc] initWithKey:VERIFIRE_KEY];
    
    return YES;
}

@end
