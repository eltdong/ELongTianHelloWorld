//
//  OrderManagerViewController.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/5.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//
#define customRow @"2"//刷新条数
#define fisrtLoadContent @"0"//第一次进入
#import "ELTOrdersSearchViewController.h"
#import "OrderManagerOneCell.h"
#import "OrderManagerTwoCell.h"
#import "OrderManagerThreeCell.h"
#import "OrderDetailViewController.h"
#import "ELTOrdersSearchViewController.h"
#import "OrderManagerSViewController.h"

#import "OrderListModel.h"
#import "OrderModel.h"
#import "RadioModel.h"

@interface ELTOrdersSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate >
{
    UIButton *_selectedBtn;
}
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableDictionary *lastDataDictionary;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView * searchView;//搜索
@property (nonatomic, strong) UITextField * searchTextField;// 搜索输入框
@end

@implementation ELTOrdersSearchViewController
//最终参数
-(NSMutableDictionary *)lastDataDictionary{
    if (!_lastDataDictionary) {
        _lastDataDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                               self.shop_id,@"shoppe_id",
                               @"orderlist",@"task",
                               customRow,@"row",
                               @"1",@"page",
                               fisrtLoadContent,@"order_id",
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
    // Do any additional setup after loading the view from its nib.
       self.page = 1;
//    [self createTopView];
    [self drop_on];
    [self drop_down];
    [self createSearchView];

 
}

#pragma mark - 创建四个button yd
-(void)createTopView{
    [_buttonOne setTitle:@"待发货\n1000" forState:UIControlStateNormal];
    _buttonOne.titleLabel.textAlignment = NSTextAlignmentCenter;
    _buttonOne.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [_buttonTwo setTitle:@"配送中\n1000" forState:UIControlStateNormal];
    _buttonTwo.titleLabel.textAlignment = NSTextAlignmentCenter;
    _buttonTwo.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [_buttonThree setTitle:@"已完成\n10" forState:UIControlStateNormal];
    _buttonThree.titleLabel.textAlignment = NSTextAlignmentCenter;
    _buttonThree.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [_buttonFour setTitle:@"已关闭\n10" forState:UIControlStateNormal];
    _buttonFour.titleLabel.textAlignment = NSTextAlignmentCenter;
    _buttonFour.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    //    _selectedBtn = [[UIButton alloc]init];
    _selectedBtn = _buttonOne;

}
#pragma mark - 创建搜索框
- (void)createSearchView{
    self.searchView = [[UIView alloc]initWithFrame:CGRectMake(self.navbar.frame.origin.x + 40, self.navbar.backbtn.frame.origin.y, SCREENWIDTH - 55, self.navbar.backbtn.frame.size.height)];
    self.searchView.backgroundColor = UIColorFromRGB(0xffffff);
    self.searchView.layer.cornerRadius = 5.0f;
    [self.navbar addSubview:self.searchView];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 5, 20, self.searchView.frame.size.height - 10)];
    imageView.image = [UIImage imageNamed:@"search_bg3"];
    [self.searchView addSubview:imageView];
    UITextField * searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(30,0, self.searchView.frame.size.width - 30, self.searchView.frame.size.height)];
    searchTextField.backgroundColor = UIColorFromRGB(0xffffff);
    searchTextField.layer.cornerRadius = 5.0f;
    searchTextField.font = UIFont(12);
    searchTextField.placeholder = @"请输入搜索内容";
    searchTextField.delegate = self;
    searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField = searchTextField;
    [self.searchView addSubview:self.searchTextField];
    self.bgTable.footer.hidden= YES;

}
#pragma mark - tableviewdelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
   
    if (self.dataArr.count!=0) {
        OrderListModel * orderListModel = self.dataArr[0];
        if (orderListModel.order.count!=0) {
//            OrderModel * omodel = orderListModel.order[indexPath.section];
            
            
            if (indexPath.row == 0) {
                return 102.f;
            }
            else if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section]-1){
                return 78.f;
            }else{
                return 23.f;
            }
        }
        else{
            return 0.f;
        }
      
    }
    
    else{
        return 0.f;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     if (self.dataArr.count!=0) {
         
        OrderListModel * orderListModel = self.dataArr[0];
         if (orderListModel.order.count!=0) {
             return orderListModel.order.count;
         }
         else{
             return 0;
         }
    }
    else{
        return 0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    
    if (self.dataArr.count!=0) {
        OrderListModel*olModel =self.dataArr[0];
        if (olModel.order.count!=0) {
             OrderModel *oModel = olModel.order[section];
            if (oModel.pro.count>3) {
                return 5;
            }
            else{
                return oModel.pro.count +2;
            }
            
        }
        else{
            return 0;
        }
    }
    else{
        return 0;
    }
    
    
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
    else if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1)
    {
        
        OrderManagerThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderManagerThreeCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderManagerThreeCell" owner:self options:nil]firstObject];
        }
        if (self.dataArr.count!=0) {
            OrderListModel * orderListModel = self.dataArr[0];
            if (orderListModel.order.count!=0) {
                OrderModel * omodel = orderListModel.order[indexPath.section];
                cell.orderModel = omodel;
            }
        }
        return cell;
        
    }else{
        
        OrderManagerTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderManagerTwoCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderManagerTwoCell" owner:self options:nil]firstObject];
        }
        if (self.dataArr.count!=0) {
            OrderListModel * orderListModel = self.dataArr[0];
            if (orderListModel.order.count!=0) {
                OrderModel * omodel = orderListModel.order[indexPath.section];
                if (omodel.pro.count!=0) {
                    ProductModel *productModel = omodel.pro[indexPath.row - 1];
                    cell.productModel  = productModel;
                }
            }
            
        }
        return cell;
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderDetailViewController *view = [[OrderDetailViewController alloc]init];
    
    OrderListModel * orderListModel = self.dataArr[0];
    OrderModel * omodel = orderListModel.order[indexPath.section];
    view.order_id = omodel.order_id;
    [self.navigationController pushViewController:view animated:YES];
    
}
#pragma mark - navbar上的按钮
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    //    _keyword = textField.text;
    NSString * keyword = textField.text;
    [keyword dataUsingEncoding:NSUTF8StringEncoding];
    [self.lastDataDictionary setObject:keyword forKey:@"keyword"];
    [self downLoadRequest:self.lastDataDictionary];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 请求数据 yd

-(void)downLoadRequest:(NSMutableDictionary *)paraDic{
    
    [self.indicator startAnimatingActivit];
    [ELRequestSingle orderListWithRequest:^(BOOL sucess, id objc) {
        [self.indicator LoadSuccess];
        if (sucess) {
            OrderListModel *olModel_temp = objc[0];
            if (olModel_temp.order.count == 0  ) {
                [self.bgTable.footer endRefreshing];
                self.bgTable.footer.hidden = YES;
                [self showAlertViewWith:@"抱歉，未找到符合的数据"];
            }
            else{
                if(olModel_temp.order.count <[customRow intValue])
                {
                    
                    [self.bgTable.footer endRefreshing];
                    self.bgTable.footer.hidden = YES;
                }
                
                
                
                if (self.page == 1) {
                    NSArray * arr = self.lastDataDictionary.allKeys;
                    for (NSInteger i = 0; i<arr.count; i++) {
                        if ([arr[i] isEqualToString:@"keyword"]) {
                            self.dataArr = objc;
                        }
                    }
                }
                else{
                    
                    OrderListModel *olModel_objc = objc[0];
                    if (self.dataArr.count!=0) {
                        OrderListModel*olModel = self.dataArr[0];
                        for (OrderModel *olModelDefault in olModel_objc.order) {
                            [olModel.order addObject:olModelDefault];
                        }
                    }
                    else
                    {
                        [self.bgTable.footer endRefreshing];
                        
                        self.bgTable.footer.hidden = YES;
                    }
                }
                [self.bgTable.header endRefreshing];
                
                [self.bgTable  reloadData];
                
                
            }
        }
        else{
             self.bgTable.footer.hidden = YES;
            [self showAlertViewWith:objc];
        }
    } andParaDic:paraDic];
    
    
    
}

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
        [weakSelf.dataArr removeAllObjects];
        [weakSelf.indicator setIndicatorType:ActivityIndicatorLogin];
        [weakSelf.lastDataDictionary setObject:@"1" forKey:@"page"];//闹不懂  强
        [weakSelf downLoadRequest: weakSelf.lastDataDictionary];
        // 马上进入刷新状态
    }];
}

@end
