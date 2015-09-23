//
//  ServiceManagementViewController.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/7.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseViewController.h"
@interface ServiceManagementViewController : BaseViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutConstraint;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
- (IBAction)dropMenuBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *dropMenuBtn;
@property (weak, nonatomic) IBOutlet UIView *dropMenuView;

@property (assign, nonatomic) int tag ;

#pragma  mark -店铺Id
@property (nonatomic,copy) NSString * shop_id;


#pragma mark - 筛选条件
- (IBAction)statusBtn:(id)sender;
- (IBAction)sortBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addtimeImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *salesImageBtn;
@property (weak, nonatomic) IBOutlet UITextField *textField;
- (IBAction)searchBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@property (nonatomic,copy) NSString * manager_id;//商家id
//判断是服务还是商品
@property (nonatomic, copy) NSString * type;
@property (nonatomic,copy) NSString * is_limit;//判断有限还是无限
@end
