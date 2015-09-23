//
//  ShopListViewController.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/4.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#define mamage_idDefault @"3"//商家id 默认为3
#define customRow @"10"//刷新条数
#import "ShopListViewController.h"
#import "ShopListCollectionViewCell.h"
#import "ShopStyleViewController.h"
#import "ShopListModel.h"
#import "HomeViewController.h"
#import "ELHttpRequestOperation.h"
#import "ELRequestSingle.h"
#import "AppDelegate.h"
#import "Const.h"
#import "LoginViewController.h"

@interface ShopListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

{
    HomeViewController * hvc;//下一级界面的的controller
    BOOL isModifyOr;//判断店铺头像和名字是否修改
}
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) NSMutableDictionary *lastDataDictionary;
@property (nonatomic,assign) NSInteger page;
@end

@implementation ShopListViewController
//最终参数
-(NSMutableDictionary *)lastDataDictionary{
    if (!_lastDataDictionary) {
        _lastDataDictionary = [NSMutableDictionary dictionaryWithObject:customRow forKey:@"row"];
        [_lastDataDictionary setObject:@"1" forKey:@"page"];
    }
    return _lastDataDictionary;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
#pragma mark - 登陆状态与数据发生改变时
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:HIDDEN_TABBAR object:@"1"];
  
    if ([ELTRefreshSingleton refreshIsOK].state) {
        _page = 1;
        [self.lastDataDictionary setObject:@"1" forKey:@"page"];
        [self downLoadRequest:self.lastDataDictionary];
        [ELTRefreshSingleton refreshIsOK].state = YES;
    }
    if (![UserLoginInfoManager loginmanager].state && NSUserDefaults_Member_id  == nil) {
        LoginViewController * login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        [self presentViewController:login animated:YES completion:nil];
        //        return;
        
    }else{
        [UserLoginInfoManager loginmanager].state = YES;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
}
- (void)createUI{
    self.navbar.backbtn.hidden = YES;
    [self.navbar.homebtn setTitle:@"添加" forState:UIControlStateNormal];
    self.navbar.titleLabel.text = @"店铺列表";
    _collctionView.backgroundColor=UIColorFromRGB(0xf5f5f5);
    _collctionView.dataSource=self;
    _collctionView.delegate=self;
    _collctionView.scrollEnabled = YES;
    // register cell
    
    [_collctionView registerNib:[UINib nibWithNibName:@"ShopListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ShopListCollectionViewCell"];
    
    _page = 1;
    [self.lastDataDictionary setObject:@"1" forKey:@"page"];
    [self downLoadRequest:self.lastDataDictionary];
    
    [self drop_down];
    [self drop_on];//加载
}
#pragma mark - UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShopListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShopListCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    if (self.dataArr.count !=0) {
        ShopListModel *model = [self.dataArr objectAtIndex:indexPath.item];
        cell.shoplistModel =model;
    }
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREENWIDTH - 45)/2, SCREENWIDTH / 1.88);
    
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

//跳转到商家中心
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    hvc = [[HomeViewController alloc]init];
    hvc.block = ^(BOOL isModify){
        if (isModify) {
            isModifyOr = YES;
        }
    };
    if (self.dataArr.count!=0) {
        ShopListModel *model = [self.dataArr objectAtIndex:indexPath.item];
        hvc.shopID = model.shopID;
        hvc.manager_id = NSUserDefaults_Member_id;
        hvc.shoplistModel = model;
    }
    [self.navigationController pushViewController:hvc animated:YES];
}
#pragma mark - navbar返回back和右侧按钮home
//返回
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
//跳转添加店铺
-(void)home:(id)sender{
    
    ShopStyleViewController *view = [[ShopStyleViewController alloc]init];
    [self.navigationController pushViewController:view animated:YES];
    
}
#pragma mark - 请求数据 yd
-(void)downLoadRequest:(NSDictionary *)dic{
    [self.view bringSubviewToFront:self.indicator];
    [self.indicator startAnimatingActivit];
    [ELRequestSingle shopListWithRequest:^(BOOL sucess, id objc) { 
        [self.indicator LoadSuccess];
        if (sucess) {
            NSArray *arr =(NSArray *)objc;
            if(arr.count <[customRow intValue])
            {
                [self.collctionView.footer endRefreshing];
                self.collctionView.footer.hidden = YES;
            }
            if (_page == 1) {
                self.dataArr = objc;
            }
            else{
                 [self.dataArr  addObjectsFromArray:objc];
            }
          
            [self.collctionView.header endRefreshing];
            [self.collctionView.footer endRefreshing];
            [self.collctionView  reloadData];
        }
        else{
//            [self showAlertViewWith:objc];
            [self.collctionView.footer  endRefreshing];
            self.collctionView.footer.hidden = YES;
            [self.collctionView.header endRefreshing];
        }
        
    } andParadict:self.lastDataDictionary];
    
}

#pragma mark - 刷新和加载
- (void)drop_on
{
    
    __weak typeof(self) weakSelf = self;
    // 添加传统的上拉加载
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.collctionView.footer.hidden = YES;
    [self.collctionView addLegendFooterWithRefreshingBlock:^{
        weakSelf.page ++ ;
        [weakSelf.indicator setIndicatorType:ActivityIndicatorLogin];
        NSString * num = [NSString stringWithFormat:@"%ld", weakSelf.page];
        [weakSelf.lastDataDictionary setValue:num forKey:@"page"];
        [weakSelf downLoadRequest: weakSelf.lastDataDictionary];

    }];
}
/**
 * UITableView + 下拉刷新 传统
 */
- (void)drop_down
{
    __weak typeof(self) weakSelf = self;
    weakSelf.collctionView.footer.hidden = YES;
    // 添加传统的下拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self.collctionView addLegendHeaderWithRefreshingBlock:^{
        
        weakSelf.page = 1;
        [weakSelf.dataArr removeAllObjects];
        [weakSelf.indicator setIndicatorType:ActivityIndicatorLogin];
        [weakSelf.lastDataDictionary setObject:@"1" forKey:@"page"];
        [weakSelf downLoadRequest: weakSelf.lastDataDictionary];
        // 马上进入刷新状态
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end 

