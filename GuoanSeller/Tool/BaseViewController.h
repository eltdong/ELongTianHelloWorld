//
//  BaseViewController.h
//  BaoJianIphone
//
//  Created by elongtian on 15-2-11.
//  Copyright (c) 2015年 madongkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Const.h"
#import "ActivityIndicator.h"
#import "RefreshControl.h"
#import "CustomRefreshView.h"
#import "UIScrollView+MJRefresh.h"
#import "MJRefreshFooter.h"
#import "MJRefreshHeader.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
@interface BaseViewController : UIViewController<JRNavDelegate,UIImagePickerControllerDelegate>{
    
}
@property (retain, nonatomic) JRNavgationBar * navbar;
@property (retain, nonatomic) UIImageView * bottom_logoV;
@property (retain, nonatomic) NSString * titleName;
@property (retain, nonatomic) ActivityIndicator * indicator;

@property (retain, nonatomic) NSString * optionid;//便于页面optionid的传值
@property (retain, nonatomic) NSString * auto_code;//便于页面optionid的传值
#pragma mark - 自定义的自动消失的框
-(void)showAlertViewWith:(NSString *)title;
- (void)showActionsheetWithPhoto;
@end
