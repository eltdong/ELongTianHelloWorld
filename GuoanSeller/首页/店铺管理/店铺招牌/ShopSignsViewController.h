//
//  ShopSignsViewController.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/7.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseViewController.h"

@interface ShopSignsViewController : BaseViewController

@property (nonatomic,strong) IBOutlet UITableView *mainTable;

@property (assign, nonatomic) float scale;

@property (retain, nonatomic) UIImage * selfimage;

@property (nonatomic,copy) NSString *shopId;

@property (nonatomic , strong) NSMutableArray *imageArray;

@property (nonatomic , strong) NSMutableArray *assets;//图片数据源

@end
