//
//   Const.h
//  TangRen
//
//  Created by 易龙天 on 15/6/8.
//  Copyright (c) 2015年 易龙天. All rights reserved.
//

#ifndef TangRen__Const_h
#define TangRen__Const_h



//#define SCREENWIDTH (CGRectGetWidth([UIScreen mainScreen].bounds) > CGRectGetHeight([UIScreen mainScreen].bounds)?CGRectGetWidth([UIScreen mainScreen].bounds):CGRectGetHeight([UIScreen mainScreen].bounds))
//#define SCREENHEIGHT (CGRectGetWidth([UIScreen mainScreen].bounds) > CGRectGetHeight([UIScreen mainScreen].bounds)?CGRectGetHeight([UIScreen mainScreen].bounds):CGRectGetWidth([UIScreen mainScreen].bounds))

#define SCREENWIDTH      CGRectGetWidth([UIScreen mainScreen].bounds)
#define SCREENHEIGHT      CGRectGetHeight([UIScreen mainScreen].bounds)


#define DELE [[UIApplication sharedApplication] delegate]
#define IOS7 [[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7

#define IOS8 [[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=8

#define NSLogFrame(v) NSLog(@"%f,%f,%f,%f",v.frame.origin.x,v.frame.origin.y,v.frame.size.width,v.frame.size.height);

#define BackGround_Color UIColorFromRGB(0xc61f2e)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define NSStringFromJson(v) (([v isEqual:[NSNull null]])?@"":v)
#define OBJC(v) (([v isEqual:[NSNull null]])?nil:v)
#define CUSTOMPLACEHOLDERIMAGE @""
#define OBJCNUM(v) ([v isEqual:[NSNull null]]||[v isEqualToString:@""] ? @"0":v)
#define OBJCREMARK(v) ([v isEqual:[NSNull null]]||[v isEqualToString:@""] ? @"":v)
#define NAVHEIGHT (IOS7?64:44)
#define IphoneHeight [UIScreen mainScreen].bounds.size.height

#define UIFont(s) ([UIFont fontWithName:@"" size:s])


//#define UIFontHiraginoSansGBW3(s) ([UIFont fontWithName:@"HiraginoSansGB-W3"size:s])
//#define UIFontHiraginoSansGBW6(s) ([UIFont fontWithName:@"HiraginoSansGB-W6"size:s])

#define USER_NAME @"user"
#define USER_PWD @"pwd"

#define LOADING @"正在加载..."

#define NO_MORE_DATA @"就这么多了"

#define NO_NET @"请检查您的网络"
#define NO_NET_DESC @"数据加载失败!"
#define NO_DATA_DESC @"暂无数据!"
#define ADD_SHOPCAR_SUCCESS @"添加购物车成功"

#define NSUserDefault_USER ([[NSUserDefaults standardUserDefaults] objectForKey:@"user"])
#define NSUserDefault_PWD ([[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"])

#define DATA_ARR ([[NSUserDefaults standardUserDefaults] objectForKey:@"dataArr"])

#define AreRemember @"isRemember"
#define is_Remember_Bool YES

#define PlaceholderImage nil

#ifdef DEBUG
# define DLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define DLog(...);
#endif

#import "UIImageView+AFNetworking.h"
#import "FileMangerObject.h"
#import "JRNavgationBar.h"
#import "ELHttpRequestOperation.h"
#import "Toast+UIView.h"
#import "NSString+Addtion.h"
#import "BJObject.h"
#import "ELRequestSingle.h"
#import "UserLoginInfoManager.h"
#import "AFNetworking.h"
#import "ELTDataArr.h"

#pragma mark - 1.时间戳 2.token值 3.商家id
#define NSUserDefaults_Time ([[NSUserDefaults standardUserDefaults] objectForKey:@"time"])
//#define NSUserDefaults_Time ([NSString stringWithFormat:@"llu",[[NSDate date] timeIntervalSince1970]])
#define NSUserDefaults_Token_Md5 ([[NSUserDefaults standardUserDefaults] objectForKey:@"token_md5"])
#define NSUserDefaults_Token ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"])
#define NSUserDefaults_Member_id ([[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"])
//#define HTTP @"http://192.168.1.153/tryy/app/index.php?com=com_appService"

#define HTTP_SUB @"http://192.168.1.166/zxga/app/index.php?com=com_appService" 


#define HTTP ([NSString stringWithFormat:@"%@&time=%@&token=%@&member_id=%@&client=2",HTTP_SUB,NSUserDefaults_Time,NSUserDefaults_Token_Md5,NSUserDefaults_Member_id])
//#define HTTP @"http://www.trfxm.com/app/index.php?com=com_appService"

#define CITY_NAME [[NSUserDefaults standardUserDefaults] objectForKey:@"city_name"]
#define CITY_CODE [[NSUserDefaults standardUserDefaults] objectForKey:@"city_code"]
//隐藏 tabBar
#define HIDDEN_TABBAR @"tabBar_Hidden"
//tabBar切换
#define SELECT_INDEX @"selectIndex"
//特价
#define TODAY_PRICE_URL @"http://www.trfxm.com/wapp/index.php?com=com_vshop&method=scarebuy"
//积分商城
#define MALL_HOME_URL @"http://www.trfxm.com/wapp/index.php?com=com_vshopcent"
//团购
#define GROUP_PURCH_URL @"http://www.trfxm.com/wapp/index.php?com=com_vshop&method=scarebuy&type=bulk"
//免费试用
#define TRYOUT_LIST_URL @"http://www.trfxm.com/wapp/index.php?com=com_vshop&method=protry"
//圈子
#define CIRCLE_HOME_URL @"http://www.trfxm.com/wapp/index.php?com=com_vcircle"
#endif
