//
//  StaffManagerViewController.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/6.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^limitBlock)(BOOL isLimit);//在人员管理页面是否开启了人员管理
@interface StaffManagerViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UISwitch *isOn;//是否开启人员管理

@property (strong, nonatomic) IBOutlet UIView *secondBottom;

@property (strong, nonatomic) IBOutlet UIView *line;

@property (strong, nonatomic) IBOutlet UICollectionView *collection;//人员列表

@property (nonatomic,strong) IBOutlet UIButton *deleteBtn;

@property (nonatomic,strong) IBOutlet UIButton *addBtn;

@property (nonatomic,copy) NSString *shopId;//店铺id

@property (nonatomic,assign) NSInteger is_limit;//是否是有限资源

- (IBAction)addBtn:(id)sender;

- (IBAction)deleteBtn:(id)sender;

- (IBAction)isOnClick:(id)sender;

@end
