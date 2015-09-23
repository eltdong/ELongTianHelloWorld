//
//  AddCommodityViewController.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/8.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseViewController.h"
#import "CommodityListModel.h"
#import "JSONKit.h"
#import "QrCodeScanningController.h"
#import "Const.h"
@protocol AddCommodityViewControllerDelegate <NSObject>

- (void)maskToStr:(NSString *)str;

@end

@interface AddCommodityViewController : BaseViewController<QrCodeScanningDelegate>

@property (strong, nonatomic) IBOutlet UITableView *bgTabel;

//@property (strong, nonatomic) IBOutlet UIButton *bottomBtn;

//- (IBAction)bottomClick:(id)sender;

@property (nonatomic,strong)  CommodityListModel * clModel;
#pragma  mark -店铺Id
@property (nonatomic,copy) NSString * shop_id;//
@property (nonatomic, copy) NSString * member_id;
@property (nonatomic,assign) BOOL isAddCommodity;//判断是否是添加商品 yes.添加 no修改

@property (nonatomic,strong)  NSMutableArray * classificationDataArr;

@property (nonatomic, assign) id<AddCommodityViewControllerDelegate> delegate;

/**
 *  标题
 */
@property (nonatomic,copy) NSString * navibarTitle;


@property (nonatomic,copy) NSString * commodity_id;//商品id
@property (nonatomic,copy) NSString * pro_id;//商品表ID
@property (nonatomic,copy) NSString * product_id;//商品库id
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgTableBottomConstraint;


@end
