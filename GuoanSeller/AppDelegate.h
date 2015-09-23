//
//  AppDelegate.h
//  GuoanSeller
//
//  Created by elongtian on 15/7/24.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELTabBar.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ELTabBar *tab;
@property (nonatomic,strong)  UITabBarController * tbc;
@end

