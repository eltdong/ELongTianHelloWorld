//
//  OrderDetailViewController.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/5.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailOneCell.h"
#import "OrderDetailTwoCell.h"
#import "OrderDetailThreeCell.h"
#import "OrderDetailFourCell.h"
#import "OrderDetailFiveCell.h"
#import "OrderDetailSixCell.h"

#import "OrderModel.h"
#import "ProductModel.h"

@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataArr;
}
@end

@implementation OrderDetailViewController
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navbar.titleLabel.text = @"订单详情";
#pragma mark - 数据请求 yd
    [self downLoad:self.order_id];
    [self.indicator setIndicatorType:ActivityIndicatorLogin];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    OrderModel *omodel = dataArr[0];
//    if (omodel.pro.count >3) {
//        return 8;
//    }else{
//        return omodel.pro.count +5;
//    }
    return omodel.pro.count +5;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderModel *omodel = dataArr[0];
    NSInteger totalNum =0;
//    if (omodel.pro.count >3) {
//        totalNum = 8;
//    }else{
//       
//    }
     totalNum = omodel.pro.count +5;
    if (indexPath.row == 0) {
        return 167;
    }else if (indexPath.row == 1){
        return 222;
    }else if (indexPath.row == 2){
        return 85;
    }else if (indexPath.row == totalNum -2){
        return 195;
    }else if (indexPath.row == totalNum -1){
        return 115;
    }else{
        return 32;
    }
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        OrderDetailOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailOneCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailOneCell" owner:self options:nil]firstObject];
        }
        if (dataArr) {
            OrderModel *oModel =dataArr[0];
            cell.oModel = oModel;
        }
        return cell;
        
    }else if (indexPath.row == 1){
        
        OrderDetailTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailTwoCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailTwoCell" owner:self options:nil]firstObject];
        }
        if (dataArr) {
            OrderModel *oModel =dataArr[0];
            cell.oModel = oModel;
        }
        return cell;
        
    }else if (indexPath.row == 2){
        
        OrderDetailThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailThreeCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailThreeCell" owner:self options:nil]firstObject];
        }
        if (dataArr) {
            OrderModel *oModel =dataArr[0];
            cell.oModel = oModel;
        }
        return cell;
        
    }else if(indexPath.row == [self tableView:tableView numberOfRowsInSection:1]-2){
        
        OrderDetailFiveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailFiveCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailFiveCell" owner:self options:nil]firstObject];
        }
         
            OrderModel *oModel =dataArr[0];
            cell.oModel = oModel;
      
        return cell;
        
    }else if (indexPath.row == [self tableView:tableView numberOfRowsInSection:1]-1){
        
        OrderDetailSixCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailSixCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailSixCell" owner:self options:nil]firstObject];
        }
        cell.vc = self;
        return cell;

        
    }else{
        
        OrderDetailFourCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailFourCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailFourCell" owner:self options:nil]firstObject];
        }
        if (dataArr) {
            OrderModel * omodel=dataArr[0];
            ProductModel * pModel =omodel.pro[indexPath.row -3];
            cell.pModel = pModel;
        }
        return cell;
        
    }
    
}

#pragma mark - navbar上的按钮
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 数据请求 yd
-(void)downLoad:(NSString *)order_id{
    [self.indicator startAnimatingActivit];
    [ELRequestSingle orderDetailWithRequest:^(BOOL sucess, id objc) {
        [self.indicator LoadSuccess];
        if (sucess) {
            dataArr = objc;
            [self.bgTable reloadData];
        }
        else{
            [self showAlertViewWith:objc];
        }
    } andProduct_id:order_id andTask:@"orderview"];
}

@end
