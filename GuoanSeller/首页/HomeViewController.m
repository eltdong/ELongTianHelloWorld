//
//  HomeViewController.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/5.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeViewCollectionViewCell.h"
#import "OrderManagerViewController.h"
#import "MyIncomeViewController.h"
#import "StaffManagerViewController.h"
#import "OrderManagerViewController.h"
#import "OrderManagerSViewController.h"
#import "ShopManagementViewController.h"
#import "LoginViewController.h"
#import "CommodityManagementViewController.h"
#import "ServiceManagementViewController.h"
#import "ELTBuyersComments.h"
#import "StatusModel.h"
#import "ShopListViewController.h"
#import "AppDelegate.h"
#import "ShopManagementViewController.h"

#define SHOPSTATUSISONSALE @"营业中"
#define SHOPSTATUSFORSALE @"休息中"
@interface HomeViewController (){
    NSArray *_imageArray;
    NSArray *_nameArray;
    NSMutableArray *_dataArr;
    ShopManagementViewController * sm;
    BOOL isModifyPhoto;
}
@property (nonatomic,assign) BOOL isOnSale;// 营业状态
@end

@implementation HomeViewController
#pragma mark - viewWillAppear ViewDidLoad
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:HIDDEN_TABBAR object:@"0"];
    if ([ELTRefreshSingleton refreshIsOK].state) {
        [self downRequest];
        [ELTRefreshSingleton refreshIsOK].state = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isModifyPhoto = NO;
    [[ELTDataArr dataArr].dataArr removeAllObjects];
     [self downRequest];
    // Do any additional setup after loading the view from its nib.
    self.navbar.titleLabel.text = @"商家中心";
    self.bottomView.layer.masksToBounds =YES;
    self.bottomView.layer.borderColor = UIColorFromRGB(0xf1f1f1).CGColor;
    self.bottomView.layer.borderWidth = 1.0f;
    
    self.navbar.homebtn.hidden = YES;
    
//    self.navbar.backbtn.hidden = YES;
    self.navbar.backgroundColor = BackGround_Color;
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    _collectionView.scrollEnabled = YES;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"HomeViewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeViewCollectionViewCell"];
    
}

- (void)push{
//    ShopManagementViewController * shop = [[ShopManagementViewController alloc]init];
//    [self.navigationController pushViewController:shop animated:YES];
}
#pragma mark - 请求数据 yd
//基本数据请求
- (void)downRequest{
    
    [self.indicator startAnimatingActivit];
    [ELRequestSingle shopListWithRequest:^(BOOL sucess, id objc) {
        
        [self.indicator LoadSuccess];
        if (sucess) {
            _dataArr = objc;
            //重加载死数据 重加载该方法
            [self addValue];
        }
        else{
//            [self showAlertViewWith:objc];
        }
    } andshopID:self.shopID];
    
}
//店铺状态修改 数据请求
- (void)downLoadStatusWithType:(NSString*)type{
    [self.indicator startAnimatingActivit];
     //    1：营业  2：停业
    [ELRequestSingle shopStatusWithRequest:^(BOOL sucess, id objc) {
        [self.indicator LoadSuccess];
        if (sucess) {
            [self.statusSwitchbutton setOn:_isOnSale];
            [self showAlertViewWith:objc];
            if (_isOnSale) {
                [self.statusLabel setText:SHOPSTATUSISONSALE];//营业
                
            }else{
                [self.statusLabel setText:SHOPSTATUSFORSALE];//休息
            }
        }
        else{
//              [self  showAlertViewWith:objc];
        }
    } andShop_iD:self.shopID andType:type];
}
#pragma mark - 店铺信息加载 yd
-(void)addValue{
    ShopListModel *model =_dataArr[0];
    [self.picImage  setImageWithURL:[NSURL URLWithString:model.content_img] placeholderImage:[UIImage imageNamed:CUSTOMPLACEHOLDERIMAGE]];
    self.nameLabel.text = model.name;
    if ([model._business_status isEqualToString:@"1"]) {
        [self.statusSwitchbutton setOn:YES];
    }else{
        [self.statusSwitchbutton setOn:NO];
    }
    [self.statusLabel setText:self.statusSwitchbutton.on?SHOPSTATUSISONSALE:SHOPSTATUSFORSALE];
    self.priceLabel.text = [NSString stringWithFormat:@"%ld",model.money];
    
    if ([self.shoplistModel.type isEqualToString:@"10"]) {
        _nameArray = @[@"店铺管理",@"服务管理",@"订单管理",@"我的评论",@"服务人员管理"];
        _imageArray = @[@"store_mants.png",@"user_ico.png",@"order.png",@"weixin.png",@"persons.png"];
    }
    else{
        _nameArray = @[@"店铺管理",@"商品管理",@"订单管理",@"我的评论"];
        _imageArray = @[@"store_mants.png",@"user_ico.png",@"order.png",@"weixin.png"];
    }
    [self.collectionView reloadData];
}
#pragma mark - collectionViewDelelgate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _nameArray.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeViewCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeViewCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.picImage.image = [UIImage imageNamed:[_imageArray objectAtIndex:indexPath.row]];
    cell.nameLabel.text = [_nameArray objectAtIndex:indexPath.row];
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREENWIDTH - 60)/3, SCREENWIDTH / 3.37);
    
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
#pragma mark - 店铺管理 yd
        sm = [[ShopManagementViewController alloc]init];
        sm.shopId = _shopID;
//        __weak typeof(self) WeakSelf = self;
        sm.block = ^(BOOL success){
            if (success) {
                isModifyPhoto = YES;
            }
        };
        [self.navigationController pushViewController:sm animated:YES];
        
    }else if(indexPath.row == 1){
        //判断是商品还是服务  20 是商品  10 是服务
#pragma mark - 商品管理
        if ([_shoplistModel.type isEqualToString:@"20"]) {//商品
            CommodityManagementViewController *vc = [[CommodityManagementViewController alloc]init];
            vc.tag = 1;
            vc.type = _shoplistModel.type;
            vc.manager_id = self.manager_id;
            vc.title = _nameArray[indexPath.row];
            ShopListModel *model =_dataArr[0];
            vc.shop_id = model.shopID;
            [self.navigationController pushViewController:vc animated:YES];
        }else if([_shoplistModel.type isEqualToString:@"10"]){//服务
            ServiceManagementViewController *vc = [[ServiceManagementViewController alloc]init];
            vc.tag = 1;
            vc.type = _shoplistModel.type;
            vc.manager_id = self.manager_id;
            vc.title = _nameArray[indexPath.row];
            ShopListModel *model =_dataArr[0];
            vc.shop_id = model.shopID;
            /**
             *  判断服务有限还是无限
             */
            vc.is_limit = [NSString stringWithFormat:@"%ld",(long)model.is_limit];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.row == 2){
#pragma mark - 订单管理 yd
        if ([_shoplistModel.type isEqualToString:@"20"]) {//商品
            
            OrderManagerViewController *view = [[OrderManagerViewController alloc]init];
            view.shop_id = self.shopID;
            [self.navigationController pushViewController:view animated:YES];
        }else if([_shoplistModel.type isEqualToString:@"10"]){//服务
            
            OrderManagerSViewController *view = [[OrderManagerSViewController alloc]init];
            view.shop_id = self.shopID; 
            [self.navigationController pushViewController:view animated:YES];
        }
 
        
    }else if (indexPath.row == 3){
        ELTBuyersComments * ebc = [[ELTBuyersComments alloc]init];
        ebc.shop_id = self.shopID;
        [self.navigationController pushViewController:ebc animated:YES];
        
    }else if (indexPath.row == 4){
        
        StaffManagerViewController *view = [[StaffManagerViewController alloc]init];
        view.shopId = self.shopID;
        ShopListModel *model =_dataArr[0];
        view.is_limit = model.is_limit;
        [self.navigationController pushViewController:view animated:YES];
    }else{
        CommodityManagementViewController *vc = [[CommodityManagementViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}
#pragma mark - navbar上的点击事件
-(void)back:(id)sender{
    if (isModifyPhoto) {
        if (self.block) {
            self.block(YES);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)myAccountClick:(id)sender {
    
    MyIncomeViewController *view = [[MyIncomeViewController alloc]init];
    ShopListModel *model =_dataArr[0];
    view.myAccount = model.money;
    [self.navigationController pushViewController:view animated:YES];
}
#pragma mark - 店铺状态
- (IBAction)statusSwitchBtn:(id)sender {
    UISwitch * statusSwitch = (UISwitch *)sender;
    // 1营业 2歇业 switch valuesChanged
    if (statusSwitch.isOn) {
        _isOnSale = YES;
        [self downLoadStatusWithType:@"1"];
    }
    else{
        _isOnSale = NO;
        [self downLoadStatusWithType:@"2"];
    }
}
@end
