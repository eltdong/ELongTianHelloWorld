//
//  AppDelegate.m
//  GuoanSeller
//
//  Created by elongtian on 15/7/24.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "AppDelegate.h"

#import "HomeViewController.h"
#import "MessageViewController.h"
#import "SettingViewController.h"
#import "ShopListViewController.h"

@interface AppDelegate (){
    HomeViewController *_homeVC;
    MessageViewController *_messageVC;
    SettingViewController *_settingVC;
    ShopListViewController * _shopListVC;
}

@end

@implementation AppDelegate

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
/*
 这与tabbar的translucent属性有关，这个属性是半透明的意思，当设置为true时，tabbar就会覆盖viewControllers下面的部分，当设置为false时，tabbar便不会覆盖
 */
- (void)tabBar_hidden:(NSNotification *)sender{
    if ([sender.object isEqualToString:@"1"]) {
        [_tab hideTabBar:nil];
        _tab.tabBar.translucent = YES;
        _tab.tabBar.bounds = CGRectMake(0, 0, 0, 0);
     }else{
        
        [_tab appearTabBar:nil];
        _tab.tabBar.translucent = NO;
    }
    // hello github  i'm coming 
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tabBar_hidden:) name:HIDDEN_TABBAR object:nil];
//    self.window.backgroundColor = UIColorFromRGB(0x666666);
    self.window.backgroundColor = [UIColor redColor];
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
#pragma mark - 根视图控制器是登陆界面 yd
    
    _shopListVC = [[ShopListViewController alloc]initWithNibName:@"ShopListViewController" bundle:nil];
 
//    self.window.rootViewController = nav_mainVC;
//    _homeVC = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    _messageVC = [[MessageViewController alloc]initWithNibName:@"MessageViewController" bundle:nil];
    _settingVC = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    
    [self setTabBarViewController:YES];//将商家中心作为首页
   
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)setTabBarViewController:(BOOL)isrescue
{
    UINavigationController * nav_forHomeVC = [[UINavigationController alloc]initWithRootViewController:_shopListVC];
    nav_forHomeVC.navigationBar.hidden = YES;
    UINavigationController * nav_forMessageVC = [[UINavigationController alloc]initWithRootViewController:_messageVC];
    nav_forMessageVC.navigationBar.hidden = YES;
    UINavigationController * nav_forSettingVC = [[UINavigationController alloc]initWithRootViewController:_settingVC];
    nav_forSettingVC.navigationBar.hidden = YES;
    NSMutableArray * vcs = [[NSMutableArray alloc]initWithObjects:nav_forHomeVC,nav_forMessageVC,nav_forSettingVC, nil];
    
    if(_tab == nil)
    {
        _tab = [[ELTabBar alloc]initWithNibName:@"ELTabBar" bundle:nil];
    }
//    _tab.hidesBottomBarWhenPushed = YES;
//    _tab.tabBar.translucent = YES;
    NSArray * titles = [[NSArray alloc]initWithObjects:@"首页",@"消息",@"设置", nil];
    NSArray * nomal_images = [[NSArray alloc]initWithObjects:@"homegrey",@"news",@"set",nil];
    NSArray * select_images = [[NSArray alloc]initWithObjects:@"home",@"newscr",@"setcr",nil];
    [_tab setTabWithArray:vcs NormalImageArray:nomal_images SelectedImageArray:select_images NomalTitles:titles SelectedTitles:titles nomalTitleColor:UIColorFromRGB(0x999999) selectedTitleColor:UIColorFromRGB(0xc61f2e) nomalBackimage:nil selectedBackimage:nil];
    [self.window setRootViewController:_tab];
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"1");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"2");

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"3");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"4");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"5");
}

@end
