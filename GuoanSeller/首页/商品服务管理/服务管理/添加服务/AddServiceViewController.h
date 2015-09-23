//
//  AddServiceViewController.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/10.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseViewController.h"
#import "CommodityListModel.h"
#import "JSONKit.h"
#import "AddServiceTableViewCell.h"
#import <AVFoundation/AVFoundation.h>

@interface AddServiceViewController : BaseViewController<UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UIButton *bottomBtn;

@property (strong, nonatomic) IBOutlet UITableView *bgTable;

@property (nonatomic,strong)  CommodityListModel * clModel;
#pragma  mark -店铺Id
@property (nonatomic,copy) NSString * shop_id;//
@property (nonatomic, copy) NSString * member_id;
@property (nonatomic,assign) BOOL isAddCommodity;//判断是否是添加商品 yes.添加 no修改

@property (nonatomic,strong)  NSMutableArray * classificationDataArr;

@property (nonatomic, strong) NSMutableArray * arr;
@property (nonatomic, copy) NSString * pro_id;
@property (nonatomic, copy) NSString * commodity_id;

- (IBAction)bottomClick:(id)sender;


@property (nonatomic,copy) NSString * is_limit;//判断店铺有限还是无限
@end
