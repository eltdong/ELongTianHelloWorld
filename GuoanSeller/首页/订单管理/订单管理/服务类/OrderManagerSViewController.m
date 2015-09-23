//
//  OrderManagerSViewController.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/7.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//
#define customRow @"6"//刷新条数
#define fisrtLoadContent @"30"//第一次进入
#import "OrderManagerSViewController.h"
#import "OrderManagerSTableViewCell.h"
#import "OrderManagerLTableViewCell.h"
#import "OrderManagerOneCell.h"
#import "ELTOrdersSearchSViewController.h"
#import "OrderDetailSViewController.h"

#import "OrderListModel.h"
#import "OrderModel.h"
#import "RadioModel.h"
@interface OrderManagerSViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIButton *_selectedBtn;
}
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableDictionary *lastDataDictionary;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,copy) NSString * is_limit;
@end

@implementation OrderManagerSViewController

-(NSMutableDictionary *)lastDataDictionary{
    if (!_lastDataDictionary) {
        _lastDataDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                               self.shop_id,@"shoppe_id",
                               @"serveorderlist",@"task",
                               customRow,@"row",
                               @"1",@"page",
                                nil];
    }
    return _lastDataDictionary;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.navbar.titleLabel.text = @"订单管理";
    [self.navbar.homebtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [self createTopView];
    [self.lastDataDictionary setObject:fisrtLoadContent forKey:@"order_id"];
    [self downLoadRequest:self.lastDataDictionary];
    [self drop_on];
    [self drop_down];
}
#pragma mark - 创建四个button yd
- (void)createTopView{
    
    [_buttonOne setTitle:@"待处理\n0" forState:UIControlStateNormal];
    _buttonOne.titleLabel.textAlignment = NSTextAlignmentCenter;
    _buttonOne.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [_buttonTwo setTitle:@"服务中\n0" forState:UIControlStateNormal];
    _buttonTwo.titleLabel.textAlignment = NSTextAlignmentCenter;
    _buttonTwo.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [_buttonThree setTitle:@"已完成\n0" forState:UIControlStateNormal];
    _buttonThree.titleLabel.textAlignment = NSTextAlignmentCenter;
    _buttonThree.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [_buttonFour setTitle:@"已关闭\n0" forState:UIControlStateNormal];
    _buttonFour.titleLabel.textAlignment = NSTextAlignmentCenter;
    _buttonFour.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    _selectedBtn = _buttonOne;

}



#pragma mark - 请求数据 yd

-(void)downLoadRequest:(NSMutableDictionary *)paraDic{
    
    [self.indicator startAnimatingActivit];
    [ELRequestSingle orderListWithRequest:^(BOOL sucess, id objc) {
        [self.indicator LoadSuccess];
        if (sucess) {
            OrderListModel *olModel_temp = objc[0];
            if ([olModel_temp.order isEqual:[NSNull null]]) {
                
            }
            else{
                if(olModel_temp.order.count <[customRow intValue])
                {
                    [self.bgTable.footer endRefreshing];
                    self.bgTable.footer.hidden = YES;
                }
                
               
                
                if (self.page == 1) {
                    self.dataArr = objc;
                }
                else{
                    
                    OrderListModel *olModel_objc = objc[0];
                    OrderListModel*olModel = self.dataArr[0];
                    for (OrderModel *olModelDefault in olModel_objc.order) {
                        [olModel.order addObject:olModelDefault];
                    }
                }
                [self.bgTable.header endRefreshing];
                
                
                [self loadWithButton];
                [self.bgTable  reloadData];
                

            }
        }
        else{
            [self showAlertViewWith:objc];
        }
    } andParaDic:paraDic];
}
#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.dataArr.count!=0) {
        OrderListModel * orderListModel = self.dataArr[0];
        if (orderListModel.order.count!=0) {
            //            OrderModel * omodel = orderListModel.order[indexPath.section];
            
            OrderModel * orderModel = orderListModel.order[indexPath.section];
            if (indexPath.row == 0) {
                return 102.f;
            }
            else if ([orderModel.is_limit isEqualToString:@"1"]){
                return 200.f;
            }else if ([orderModel.is_limit isEqualToString:@"2"]) {
                return 144.f;
            }
        }
    }
    return 0.f;
    

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataArr.count) {
        OrderListModel * orderListModel= self.dataArr[0];
        if (orderListModel.order) {
            return orderListModel.order.count;
        }
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        OrderManagerOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderManagerOneCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderManagerOneCell" owner:self options:nil]firstObject];
        }
        if (self.dataArr.count!=0 ) {
            OrderListModel * orderListModel = self.dataArr[0];
            if (orderListModel.order.count!=0) {
                cell.orderModel = orderListModel.order[indexPath.section];
            }
        }

        return cell;
    }
    else{
        if (self.dataArr.count!=0 ) {
            OrderListModel * orderListModel = self.dataArr[0];
            if (orderListModel.order.count!=0) {
                OrderModel * orderModel = orderListModel.order[indexPath.section];
                if ([orderModel.is_limit isEqualToString:@"1"]) {
                    OrderManagerLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderManagerLTableViewCell"];
                    if (!cell) {
                        cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderManagerLTableViewCell" owner:self options:nil]firstObject];
                    }
                    cell.serviceModel = orderModel.sev[indexPath.row - 1];
                    cell.orderModel = orderModel;
                    return cell;
                }
                else{
                    OrderManagerSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderManagerSTableViewCell"];
                    if (!cell) {
                        cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderManagerSTableViewCell" owner:self options:nil]firstObject];
                    }
                    cell.serviceModel = orderModel.sev[indexPath.row - 1];
                    cell.orderModel = orderModel;
                    return cell;
                }
            }
        }
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"121"];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
    
}
//跳转到订单详情页
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderDetailSViewController *view = [[OrderDetailSViewController alloc]init];
    OrderListModel * orderListModel = self.dataArr[0];
    OrderModel * omodel = orderListModel.order[indexPath.section];
    view.order_id = omodel.order_id;
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark - navbar上的按钮
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)home:(id)sender{
    ELTOrdersSearchSViewController * vc = [[ELTOrdersSearchSViewController alloc]init];
    vc.shop_id = self.shop_id;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 四种订单状态的点击事件
- (IBAction)buttonClick:(id)sender {

    UIButton *button = sender;
    if (_selectedBtn.tag == button.tag) {
        return;
    }else{
        [button setTitleColor:UIColorFromRGB(0xC61F2E) forState:UIControlStateNormal];
        [_selectedBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        _selectedBtn = button;
        [UIView animateWithDuration:0.3 animations:^{
            _lineView.frame = CGRectMake(button.frame.origin.x, _lineView.frame.origin.y, _lineView.frame.size.width, _lineView.frame.size.height);
        }];
        
        NSString *str;
        switch (button.tag) {
            case 1:
            {
                str = @"30";
            }
                break;
            case 2:
            {
                str = @"40";
            }
                break;
            case 3:
            {
                str = @"60";
            }
                break;
            case 4:
            {
                str = @"90";
            }
                break;
                
            default:
                break;
        }
        [self.lastDataDictionary setObject:str forKey:@"order_id"];
        if (self.dataArr) {
            OrderListModel * olModel = self.dataArr[0];
            [olModel.order removeAllObjects];
        }
        self.page = 1;
        [self.lastDataDictionary setObject:@"1" forKey:@"page"];
        [self downLoadRequest:self.lastDataDictionary];
        [self.indicator setIndicatorType:ActivityIndicatorLogin];
        
    }
    


}
#pragma mark -为button赋值
-(void)loadWithButton{
    
    OrderListModel * orderListModel = self.dataArr[0];
    
    RadioModel * radioModel0 = orderListModel.radio[0];
    [_buttonOne setTitle:[NSString stringWithFormat:@"%@\n( %@ )",radioModel0.label,radioModel0.num] forState:UIControlStateNormal];
    
    RadioModel * radioModel1 = orderListModel.radio[1];
    
    [_buttonTwo setTitle:[NSString stringWithFormat:@"%@\n( %@ )",radioModel1.label,radioModel1.num]  forState:UIControlStateNormal];
    RadioModel * radioModel2 = orderListModel.radio[2];
    
    [_buttonThree setTitle:[NSString stringWithFormat:@"%@\n( %@ )",radioModel2.label,radioModel2.num]  forState:UIControlStateNormal];
    RadioModel * radioModel3 = orderListModel.radio[3];
    
    [_buttonFour setTitle:[NSString stringWithFormat:@"%@\n( %@ )",radioModel3.label,radioModel3.num]  forState:UIControlStateNormal];
    
    
}
#pragma mark - 刷新和加载
- (void)drop_on
{
    
    __weak typeof(self) weakSelf = self;
    // 添加传统的上拉加载
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self.bgTable addLegendFooterWithRefreshingBlock:^{
        weakSelf.page ++ ;
        [weakSelf.indicator setIndicatorType:ActivityIndicatorLogin];
        NSString * num = [NSString stringWithFormat:@"%ld",weakSelf. page];
        //        [self.lastDataDictionary setObject:row forKey:@"row"]; value 和object 的区别
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
    // 添加传统的下拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self.bgTable addLegendHeaderWithRefreshingBlock:^{
        
        weakSelf.page = 1;
        OrderListModel * olModel = weakSelf.dataArr[0];
        [olModel.order removeAllObjects];
        [weakSelf.indicator setIndicatorType:ActivityIndicatorLogin];
        [weakSelf.lastDataDictionary setObject:@"1" forKey:@"page"];//闹不懂  强
        [weakSelf downLoadRequest: weakSelf.lastDataDictionary];
        // 马上进入刷新状态
    }];
}


@end
