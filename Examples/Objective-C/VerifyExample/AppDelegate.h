//
//  AppDelegate.h
//  VerifyExample
//
//  Created by Sergey P on 22.09.17.
//  Copyright © 2017 Sergey Popov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VFVerifire;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) VFVerifire *veriFire;

@end

