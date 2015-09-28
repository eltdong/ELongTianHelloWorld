//
//  CJDrawerViewController.h
//  TangRen
//
//  Created by 易龙天 on 15/6/15.
//  Copyright (c) 2015年 易龙天. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJDrawerVCTableViewCell.h"
#import "ScreenDetailViewController.h"
@protocol CJDrawerViewControllerDelegate <NSObject>

- (void)cancleBtnClicked:(id)sender;
- (void)OKBtnClicked:(id)sender;

@end

@interface CJDrawerViewController : UIViewController<ScreenDetailViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *tabBar;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancel;
@property (strong, nonatomic) IBOutlet UIButton *OK;
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) IBOutlet UIView *bj_view;
@property (strong, nonatomic) IBOutlet UIView *bj_view_tabbleview;
@property (nonatomic, copy) NSString * code;


@property (nonatomic, assign) id<CJDrawerViewControllerDelegate>delegate;

- (void)pushAnimation;
- (void)popAnimation;
@end
