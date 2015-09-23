//
//  OrderDetailSViewController.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/7.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "OrderDetailSViewController.h"
#import "OrderDetailOneCell.h"
#import "OrderDetailTwoCell.h"
#import "OrderDetailSTableViewCell.h"
#import "OrderDetailSixCell.h"

@interface OrderDetailSViewController ()
{
    NSMutableArray *dataArr;
}
@end

@implementation OrderDetailSViewController
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navbar.titleLabel.text = @"订单详情"; 
    [self downLoad:self.order_id];
    [self.indicator setIndicatorType:ActivityIndicatorLogin];
}
#pragma mark - 数据请求 yd
-(void)downLoad:(NSString *)order_id{
    [self.indicator startAnimatingActivit];
    [ELRequestSingle orderDetailWithRequest:^(BOOL sucess, id objc) {
        [self.indicator LoadSuccess];
        dataArr = objc;
        [self.bgTable reloadData];
    } andProduct_id:order_id andTask:@"serveorderview"];
}
#pragma mark - tableViewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 167;
    }else if (indexPath.row == 1){
        return 222;
    }else if (indexPath.row == 3){
        return 115;
    }else{
        return 280;
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
        
    }else if (indexPath.row == 3){
        
        OrderDetailSixCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailSixCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailSixCell" owner:self options:nil]firstObject];
        }
        return cell;
        
    }else{
        
        OrderDetailSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailSTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailSTableViewCell" owner:self options:nil]firstObject];
        }
        if (dataArr) {
            OrderModel *oModel = dataArr[0];
            cell.orderModel = oModel;
            cell.serviceModel = oModel.sev[0];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
