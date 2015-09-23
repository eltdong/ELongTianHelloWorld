//
//  OrderManagerViewController.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/5.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseViewController.h"

@interface ELTOrdersSearchViewController : BaseViewController


@property (strong, nonatomic) IBOutlet UITableView *bgTable;
#pragma mark - 四个button
@property (strong, nonatomic) IBOutlet UIButton *buttonOne;

@property (strong, nonatomic) IBOutlet UIButton *buttonTwo;

@property (strong, nonatomic) IBOutlet UIButton *buttonThree;

@property (strong, nonatomic) IBOutlet UIButton *buttonFour;

@property (strong, nonatomic) IBOutlet UIView *lineView;

 

#pragma mark - 店铺Id
@property (nonatomic,copy) NSString * shop_id; 

@end
