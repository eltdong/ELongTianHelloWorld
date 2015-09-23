//
//  OrderManagerSViewController.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/7.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//
#define customRow @"10"//刷新条数
#define fisrtLoadContent @"1"//第一次进入
#define NAVIGATIONBARTITLE @"我的评论"
#import "ELTBuyersComments.h"
#import "ELTBuyerCommentsCell.h"
#import "RadioModel.h" 
#import "ELTCommentListModel.h"
#import "ELTReviewModel.h"

@interface ELTBuyersComments ()<UITableViewDataSource,UITableViewDelegate>
{
    UIButton *_selectedBtn;
}
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableDictionary *lastDataDictionary;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,copy) NSString * is_limit;
@end

@implementation ELTBuyersComments

-(NSMutableDictionary *)lastDataDictionary{
    if (!_lastDataDictionary) {
//        http://192.168.1.166/zxga/app/index.php?com=com_appService&method=appSev&app_com=com_appcorpcenter&task=commentlist
        _lastDataDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                               self.shop_id,@"shoppe_id",
                               @"commentlist",@"task",
                               customRow,@"row",
                               @"1",@"page",
                               @"1",@"type",
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
    self.navbar.titleLabel.text = NAVIGATIONBARTITLE;
    [self createTopView];
//        self.dataArr = @[@"1\n2\n3\n4\n5\n6", @"123456789012345678901234567890", @"1\n2", @"1\n2\n3", @"1"];
    [self.lastDataDictionary setObject:fisrtLoadContent forKey:@"type"];
    [self downLoadRequest:self.lastDataDictionary];
    [self drop_on];
    [self drop_down];
    
}
- (void)createTopView{
    
//    [_buttonOne setTitle:@"待服务\n1000" forState:UIControlStateNormal];
    _buttonOne.titleLabel.textAlignment = NSTextAlignmentCenter;
    _buttonOne.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
//    [_buttonTwo setTitle:@"服务中\n1000" forState:UIControlStateNormal];
    _buttonTwo.titleLabel.textAlignment = NSTextAlignmentCenter;
    _buttonTwo.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
//    [_buttonThree setTitle:@"已完成\n10" forState:UIControlStateNormal];
    _buttonThree.titleLabel.textAlignment = NSTextAlignmentCenter;
    _buttonThree.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
//    [_buttonFour setTitle:@"已关闭\n10" forState:UIControlStateNormal];
//    _buttonFour.titleLabel.textAlignment = NSTextAlignmentCenter;
//    _buttonFour.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    _selectedBtn = _buttonOne;

}
#pragma mark - 请求数据 yd

-(void)downLoadRequest:(NSMutableDictionary *)paraDic{
    
    [self.indicator startAnimatingActivit];
    [ELRequestSingle commentListWithRequest:^(BOOL sucess, id objc) {
        [self.indicator LoadSuccess];
        if (sucess) {
            ELTCommentListModel *olModel_temp = objc[0];
            if ([olModel_temp.review isEqual:[NSNull null]]) {
                
            }
            else{
                if(olModel_temp.review.count <[customRow intValue])
                {
                    [self.bgTable.footer endRefreshing];
                    self.bgTable.footer.hidden = YES;
                }
               
                if (olModel_temp.review.count == 0) {
                    [self showAlertViewWith:@"抱歉，没有找到相关数据"];
                    return ;
                }
                if (self.page == 1) {
                    self.dataArr = objc;
                }
                else{
                    
                    ELTCommentListModel *olModel_objc = objc[0];
                    ELTCommentListModel*olModel = self.dataArr[0];
                    for (ELTReviewModel *olModelDefault in olModel_objc.review) {
                        [olModel.review addObject:olModelDefault];
                    }
                }
                [self.bgTable.header endRefreshing];
                [self.bgTable.footer endRefreshing];
                
                [self loadWithButton];
                [self.bgTable  reloadData];
            }
        }
        else{
 
            [self.bgTable.header endRefreshing];
             self.bgTable.footer.hidden = YES;
         }
    } andParaDic:paraDic];
}
#pragma mark - tableView delegate

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArr.count!=0) {
        ELTCommentListModel * orderListModel = self.dataArr[0];
        if (orderListModel.review.count!=0) {
            return orderListModel.review.count;
        }
    }
        return 0;
   
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* ID = @"ELTBuyerCommentsCell";
    ELTBuyerCommentsCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ELTBuyerCommentsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (self.dataArr.count!=0) {
        ELTCommentListModel * orderListModel = self.dataArr[0];
        if (orderListModel.review.count!=0) {
            ELTReviewModel * omodel = orderListModel.review[indexPath.row];
            cell.model = omodel;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell =(ELTBuyerCommentsCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark - navbar上的按钮
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -为button赋值
-(void)loadWithButton{
    
    ELTCommentListModel * orderListModel = self.dataArr[0];
    
    RadioModel * radioModel0 = orderListModel.radio[0];
    [_buttonOne setTitle:[NSString stringWithFormat:@"%@\n( %@ )",radioModel0.label, radioModel0.num] forState:UIControlStateNormal];
    
    RadioModel * radioModel1 = orderListModel.radio[1];
    [_buttonTwo setTitle:[NSString stringWithFormat:@"%@\n( %@ )",radioModel1.label,radioModel1.num]  forState:UIControlStateNormal];
    
    RadioModel * radioModel2 = orderListModel.radio[2];
    [_buttonThree setTitle:[NSString stringWithFormat:@"%@\n( %@ )",radioModel2.label,radioModel2.num]  forState:UIControlStateNormal];
    
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
        
        //        10：待发货30
        //        20：配送中40
        //        30：已完成60
        //        40：已关闭90
        
        //        NSString * str = [NSString stringWithFormat:@"%ld",button.tag *10];
        NSString *str;
        switch (button.tag) {
            case 1:
            {
                str = @"1";
            }
                break;
            case 2:
            {
                str = @"2";
            }
                break;
            case 3:
            {
                str = @"3";
            }
                break;
            default:
                break;
        }
        [self.lastDataDictionary setObject:str forKey:@"type"];
        
        if (self.dataArr.count) {
            ELTCommentListModel * olModel = self.dataArr[0];
            [olModel.review removeAllObjects];
        }
        self.page = 1;
        [self.lastDataDictionary setObject:@"1" forKey:@"page"];
        [self downLoadRequest:self.lastDataDictionary];
        [self.indicator setIndicatorType:ActivityIndicatorLogin];
        
    }
    
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
        if (weakSelf.dataArr.count) {
            ELTCommentListModel * olModel = weakSelf.dataArr[0];
            [olModel.review removeAllObjects];
        }
        [weakSelf.indicator setIndicatorType:ActivityIndicatorLogin];
        [weakSelf.lastDataDictionary setObject:@"1" forKey:@"page"];//闹不懂  强
        [weakSelf downLoadRequest: weakSelf.lastDataDictionary];
        // 马上进入刷新状态
    }];
}


@end
