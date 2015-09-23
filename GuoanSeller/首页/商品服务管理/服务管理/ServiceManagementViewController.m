//
//  ServiceManagementViewController.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/7.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//


#define customRowNum @"6"
#import "ServiceManagementViewController.h"

#import "AddCommodityViewController.h"

#import "ServiceManagement_sec_TableViewCell.h"
#import "DropDownMenuView.h"

#import "AddServiceViewController.h"

#import "CommodityListModel.h"
@interface ServiceManagementViewController ()<UITableViewDataSource,UITableViewDelegate,DropDownMenuViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,AddCommodityViewControllerDelegate,UITextFieldDelegate>
{
    
    NSInteger _page;//分页
    CGFloat lastScrollViewContenOffSetY;
    NSString * task;
    NSString * taskClass;
    NSString * taskDel;
    BOOL isModify;
    BOOL isSearch;
    AddServiceViewController * view;
}
@property (nonatomic,strong) DropDownMenuView *ddmv;//下拉菜单
@property (nonatomic,weak) NSString * isChangedStr;//记录分类名称
@property (nonatomic,copy) NSString *classificationAutoId;//分类id
@property (nonatomic,strong) UIButton *selectedBtn;//第一次选中的button
@property (nonatomic,strong) NSMutableArray * dataArr;//tableview的数据源
@property (nonatomic,strong) NSMutableArray *classificationArr;//分类的数据源
@property (nonatomic,strong) NSMutableDictionary *lastDataDictionary;//实时参数
@property (nonatomic,strong) NSIndexPath *currentIndexPath;//记录当前选中的cell
@property (nonatomic,strong) UIButton *selectedStatusBtn;// 选中筛选按钮
@end

@implementation ServiceManagementViewController
//最终参数
-(NSMutableDictionary *)lastDataDictionary{
    if (!_lastDataDictionary) {
        _lastDataDictionary = [NSMutableDictionary dictionaryWithObject:OBJCNUM(self.shop_id)  forKey:@"shoppe_id"];
        [_lastDataDictionary setObject:@"0" forKey:@"auto_code"];
        [_lastDataDictionary setObject:@"1" forKey:@"page"];
    }
    return _lastDataDictionary;
}
-(NSString *)isChangedStr{
    if (!_isChangedStr ) {
        _isChangedStr = @"全部";
    }
    return _isChangedStr;
}
 -(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

#pragma mark - viewWillAppear viewDidLoad
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:HIDDEN_TABBAR object:@"1"];
    if ([ELTRefreshSingleton refreshIsOK].state) {
        [self.tableView.header beginRefreshing];
        [ELTRefreshSingleton refreshIsOK].state = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    isSearch = NO;
    _page = 1;
    if ([_type isEqualToString:@"20"]) {
        task = @"prolists";
        taskClass = @"proclass";
    }else{
        task = @"servelists";
        taskClass = @"serveclass";
    }
    self.classificationAutoId = @"0";//初始化为全部
    self.selectedStatusBtn.selected = YES;//上架状态
    self.selectedBtn.selected = YES;//时间和销量
    [self createUI];
    [self drop_on ];
    [self drop_down];
}
#pragma mark - 商品列表请求数据 yd
-(void)downLoadRequest:(NSMutableDictionary * )paraDict{
    
    [self.indicator startAnimatingActivit];
    [ELRequestSingle commodityListWithRequest:^(BOOL sucess, id objc) {
        
        [self.indicator LoadSuccess];
        if (sucess) {
            NSArray *arr =(NSArray *)objc;
            if (isSearch && arr.count == 0) {
                isSearch = NO;
                self.tableView.footer.hidden = YES;
                [self showAlertViewWith:@"抱歉，未找到符合的数据"];
                [self.lastDataDictionary setObject:@"" forKey:@"keyword"];
                return ;
            }
            if(arr.count <[customRowNum intValue])
            {
                [self.tableView.footer endRefreshing];
                self.tableView.footer.hidden = YES;
                
            }
            [self.tableView.header endRefreshing];
            [self.dataArr  addObjectsFromArray:objc];
            [self.tableView  reloadData];
            if (_page == 1) {
                [self topviewBackToOriginalPosition];
            }

        }
        else{
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
            self.tableView.footer.hidden = YES;
        }
    }  andParameters:paraDict andTask:task];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createUI{
    self.navbar.titleLabel.text = @"服务管理";
    [self.navbar.homebtn setTitle:@"添加" forState:UIControlStateNormal];
    /**
     *  搜索框加圆角
     */
    [self.indicator setIndicatorType:ActivityIndicatorLogin];
    self.searchView.layer.masksToBounds = YES;
    self.searchView.layer.cornerRadius = 2.5f;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dropMenuBtn:)];
    [self.dropMenuView addGestureRecognizer:tap];
    [self downLoadRequest:self.lastDataDictionary];
}
#pragma mark - 刷新加载
- (void)drop_on
{

    __weak typeof(self) weakSelf = self;
    // 添加传统的上拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        _page++ ;
        [weakSelf.indicator setIndicatorType:ActivityIndicatorLogin];
        NSString * num = [NSString stringWithFormat:@"%ld",_page];
//        [self.lastDataDictionary setObject:row forKey:@"row"]; value 和object 的区别
        [self.lastDataDictionary setValue:num forKey:@"page"];
        [weakSelf downLoadRequest: self.lastDataDictionary];
    }];
}
- (void)drop_down
{
    __weak typeof(self) weakSelf = self;
    // 添加传统的下拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        _page = 1;
        if (weakSelf.dataArr.count ==0) {
            [self.tableView.footer noticeNoMoreData];
        }
        [weakSelf.dataArr removeAllObjects];
        [weakSelf.indicator setIndicatorType:ActivityIndicatorLogin];
        [self.lastDataDictionary setObject:@"1" forKey:@"page"];
        [weakSelf downLoadRequest:self.lastDataDictionary];
        // 马上进入刷新状态
    }];
}

#pragma mark - home or back
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
// 跳转到添加到服务页面
-(void)home:(id)sender{
        if ([self.type isEqualToString:@"20"]) {
            AddCommodityViewController *add = [[AddCommodityViewController alloc]init];
            add.isAddCommodity = YES;//添加
            add.shop_id = self.shop_id;
            add.member_id = self.manager_id;
            add.navibarTitle = @"添加商品";
            add.delegate = self;
            [self.navigationController pushViewController:add animated:YES];
        }else{
           view = [[AddServiceViewController alloc]init];
            view.shop_id = self.shop_id;
            view.isAddCommodity = YES;//添加
            view.is_limit = self.is_limit;
            [self.navigationController pushViewController:view animated:YES];

        }
 
}
- (void)maskToStr:(NSString *)str{
    [self showAlertViewWith:str];
}
#pragma mark - tableView delegate yd
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString * cellID2 = @"cmvc2";

    ServiceManagement_sec_TableViewCell *cell2  = [tableView dequeueReusableCellWithIdentifier:cellID2];
    if (!cell2) {
        cell2 = [[[NSBundle mainBundle]loadNibNamed:@"ServiceManagement_sec_TableViewCell" owner:self options:nil]lastObject];
        
    }
    [cell2.bjView.layer removeAllAnimations];
    cell2.content_name.contentMode = UIViewContentModeBottomRight;
    cell2.serviceAttitude.contentMode = UIViewContentModeTopLeft;
    
    if (self.dataArr.count !=0) {
        CommodityListModel *clModel = self.dataArr[indexPath.row];
        
        cell2.clModel = clModel;
        if ([_type isEqualToString:@"10"]) {
            [cell2.product_id setText:[NSString stringWithFormat:@"￥%@",OBJCNUM(clModel.price)]];
            cell2.content_preprice.hidden = YES;
            cell2.favorablePrice_name.hidden = YES;
        }
    }
     return cell2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 116.f ;
}
// 跳转到服务修改页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.type isEqualToString:@"20"]) {
        CommodityListModel * clModel = self.dataArr[indexPath.row];
        AddCommodityViewController*add = [[AddCommodityViewController alloc]init];
        add.clModel = clModel;
        add.shop_id = clModel.shoppe_id;
        add.member_id = clModel.member_id;
        add.pro_id = clModel.product_id;//商品表ID
        //    add.product_id = clModel.product_id;
        /**
         *  商品id
         */
        add.commodity_id = clModel.commodity_id;
        
        add.isAddCommodity = NO;//修改
        add.navibarTitle =@"修改商品";
        [self.navigationController pushViewController:add animated:YES];
    }else{
        CommodityListModel * clModel = self.dataArr[indexPath.row];
        view = [[AddServiceViewController alloc]init];
        view.shop_id = clModel.shoppe_id;
        view.clModel = clModel;
        view.member_id = clModel.member_id;
        /**
         *  商品id
         */
        
        view.commodity_id = clModel.commodity_id;
        
        view.isAddCommodity = NO;//修改
        
         view.is_limit = self.is_limit;
        [self.navigationController pushViewController:view animated:YES];
    }

}

#pragma mark - tableView的删除功能
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;//打开编辑功能
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否要删除该产品？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        self.currentIndexPath = indexPath;
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
//修改删除按钮
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
     return @"删除";
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            self.tableView.editing = UITableViewCellEditingStyleNone ;//改变tableview的编辑状态即可，无需改变cell的编辑状态
        }
            break;
        case 1:
        {CommodityListModel * model = self.dataArr[self.currentIndexPath.row];
            NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithObject:model.commodity_id forKey:@"id"];
            [self commodityDeleteRequest:dict];
        }
            break;
        default:
            break;
    }
}


#pragma mark - 加载下拉菜单 点击全部

//去掉button的点击事件
- (IBAction)dropMenuBtn:(id)sender {
    self.selectedStatusBtn.selected = NO;
    if (self.classificationArr) {
        [self createDropMenuView:self.classificationArr];
    }
    else{
        [self downloadClassificationRequest:[_lastDataDictionary objectForKey:@"shoppe_id"]];
    }
    
}
-(void)downloadClassificationRequest:(NSString * )shop_id{
    [self.indicator startAnimatingActivit];
    [ELRequestSingle classificationWithRequest:^(BOOL sucess, id objc) {
        [self.indicator LoadSuccess];
        if (sucess) {
            self.classificationArr =objc;
            if (self.classificationArr.count == 0) {
                [self showAlertViewWith:@"暂无分类"];
            }
            else{
                [self createDropMenuView:self.classificationArr];
            }
            
        }
        else{
            [self showAlertViewWith:@"暂无分类"];
        }

    } andShope_id:shop_id andTask:taskClass];
}
-(void)createDropMenuView:(NSMutableArray *)dataArr{
//    DropDownMenuView *ddmv = [DropDownMenuView instanceView:nil];
    DropDownMenuView *ddmv = [[[DropDownMenuView alloc]init] instanceCustomView:dataArr];
//    ddmv.dropDownMenuViewType = DropDownMenuViewRemoveAll;
    ddmv.frame = self.view.bounds;
    ddmv.delegate = self;
    ddmv.dataArr = dataArr;
    [self.view addSubview:ddmv];
    self.ddmv = ddmv;
}
#pragma mark - 删除请求
-(void)commodityDeleteRequest:(NSMutableDictionary *)paraDict{
    [self.indicator startAnimatingActivit];
    taskDel = @"delserve";
    [ELRequestSingle commodityDeleteWithRequest:^(BOOL sucess, id objc) {
        if ([objc[0]  isEqual: @"1"]) {
            [self.indicator LoadSuccess];
            [self.dataArr removeObjectAtIndex:self.currentIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.currentIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            //        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"删除成功" delegate:self cancelButtonTitle:nil otherButtonTitles:  nil];
            
            [NSTimer scheduledTimerWithTimeInterval:0.5
                                             target:self
                                           selector:@selector(timerFireMethod:)
                                           userInfo:alertView
                                            repeats:NO];//自动消失的alertview
            [alertView show];
        }else {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"删除失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:  nil];
            [alertView show];
            [self.indicator LoadSuccess];
        }
    } andParameters:paraDict andTask:taskDel];
}
- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
   
}

#pragma mark - 选择分类时加载数据
-(void)didSelectRowAtIndexPathWithText:(NSString *)text andAuto_code:(NSString *)auto_code{
    [self.ddmv removeFromSuperview];
    self.isChangedStr = text;//记录分类名称
    [self.dropMenuBtn setTitle:_isChangedStr forState:UIControlStateNormal];
    self.classificationAutoId = auto_code;//记录分类id
    /**
     *  刷新数据
     */
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjects:@[[_lastDataDictionary objectForKey:@"shoppe_id"],auto_code] forKeys:@[@"shoppe_id",@"auto_code"]];
    
    [self.dataArr removeAllObjects];
    _page = 1;
    [self downLoadRequest:dic];
    self.lastDataDictionary = dic;//重置参数
//重置分类，需要重置筛选状态
    [self.addtimeImageBtn setImage:[UIImage imageNamed:@"sort"] forState:UIControlStateNormal];
    [self.salesImageBtn setImage:[UIImage imageNamed:@"sort"] forState:UIControlStateNormal];
}
#pragma mark - 状态筛选按钮yd
- (IBAction)statusBtn:(id)sender {
    /**
     *  tag 11 12 13    上架:1,下架:0  type     
     */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    UIButton *btn = sender;
    
    switch (btn.tag) {
        case 11:
        {
            [dic setValue:@"2" forKey:@"type"];
        }
            break;
        case 12:
        {
            [dic setValue:@"3" forKey:@"type"];
        }
            break;
        case 13:
        {
            [dic setValue:@"1" forKey:@"type"];
         }
            break;
        default:
            break;
    }
    
    [self.lastDataDictionary addEntriesFromDictionary:dic];
    [self.dataArr removeAllObjects];
    
    //去除多次选择同一个按钮
    if (self.selectedStatusBtn.tag != btn.tag) {
        _page = 1;
        [self.lastDataDictionary setObject:@"1" forKey:@"page"];
        [self downLoadRequest:self.lastDataDictionary];
    }
    self.selectedStatusBtn.selected = NO; 
    btn.selected = YES;
    [btn setTitleColor:UIColorFromRGB(0xC61F2E) forState:UIControlStateSelected];
    [btn setTitleColor:UIColorFromRGB(0xC61F2E) forState:UIControlStateDisabled];
    self.selectedStatusBtn = btn;
}
#pragma mark - 添加时间和销量
- (IBAction)sortBtn:(id)sender {
    //            1:按销量降序
    //            2:按销量升序
    //            3:按时间降序
    //            4:按时间升序
    //            5:按价格降序
    //            6:按价格升序
    UIButton *btn = sender;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    switch (btn.tag) {
        case 14:
        case 15:
        {
            [self.salesImageBtn setImage:[UIImage imageNamed:@"sort"] forState:UIControlStateNormal];
            static int i= 0;
            [dic setValue:i%2==0?@"3":@"4" forKey:@"sort"];
            [self.addtimeImageBtn setImage:[UIImage imageNamed:i%2==0?@"sortup":@"sortdown"] forState:UIControlStateNormal];
            i++;
            
        }
            break;
        case 16:
        case 17:
        {
            [self.addtimeImageBtn setImage:[UIImage imageNamed:@"sort"] forState:UIControlStateNormal];
            static int i= 0;
            [dic setValue:i%2==0?@"1":@"2" forKey:@"sort"];
            [self.salesImageBtn setImage:[UIImage imageNamed:i%2==0?@"sortup":@"sortdown"] forState:UIControlStateNormal];
            i++;
        }
            break;
        default:
            break;
    }
    [self.lastDataDictionary addEntriesFromDictionary:dic];
    [self.dataArr removeAllObjects];
    _page = 1;
    [self downLoadRequest:self.lastDataDictionary];
}
#pragma mark - 搜索
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.tag = 100;
}
//键盘的搜索键响应
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    isSearch = YES;
    [self.dropMenuBtn setTitle:@"全部" forState:UIControlStateNormal];
    //移除键盘
    UITextField *tf = (UITextField *)[self.view viewWithTag:100];
    [tf resignFirstResponder];
    [self.addtimeImageBtn setImage:[UIImage imageNamed:@"sort"] forState:UIControlStateNormal];
    [self.salesImageBtn setImage:[UIImage imageNamed:@"sort"] forState:UIControlStateNormal];
    
    NSString * keyword = self.textField.text;
    //    self.textField.text = @""; // 搜索完不清空
    [keyword dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:keyword forKey:@"keyword"];
    [dic setValue:[_lastDataDictionary objectForKey:@"shoppe_id"] forKey:@"shoppe_id"];
    [dic setValue:@"1" forKey:@"page"];
    self.lastDataDictionary = dic;
    [self.dataArr removeAllObjects];//清空
    _page = 1;
    [self downLoadRequest:dic];
    return YES;
}
- (IBAction)searchBtn:(id)sender {
    
}
// 实时搜索
-(void)customTextFieldDidChange:(UITextField *)textField{
    NSString * keyword =  textField.text;
    [keyword dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:keyword forKey:@"keyword"];
    [dic setValue:[_lastDataDictionary objectForKey:@"shoppe_id"] forKey:@"shoppe_id"];
    [self downLoadRequest:dic];
    
}
//上面的view是否显示
BOOL isView = YES;
#pragma mark - 滑动效果
//开始拖拽视图
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    lastScrollViewContenOffSetY = scrollView.contentOffset.y;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat currentPosition = scrollView.contentOffset.y;
    
    if(self.dataArr.count > 10){
        if ([scrollView isKindOfClass:[UITableView class]])
        {
            if (lastScrollViewContenOffSetY< scrollView.contentOffset.y &&scrollView.contentOffset.y>185.f)//上拉 且 滑动位置>185.f
            {
                if (isView == YES) {
                    [self hiddenTopView:self.topView];
                }
            }
            else if (currentPosition<249.f) {
                if (isView == NO) {
                    [self showTopView:self.topView withConstant:249.f];
                }
                self.tableViewLayoutConstraint.constant = 249.f ;
                self.topViewLayoutConstraint.constant = 64.f;
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
            }
            
            if (lastScrollViewContenOffSetY > scrollView.contentOffset.y &&lastScrollViewContenOffSetY - currentPosition>800.f)//向下滑动，一次性滑动800.f 假速率的问题
            {
                if (isView == NO) {
                    [self showTopView:self.topView withConstant:64.f];
                    
                }
                
            }
            
            
        }
    }
}


-(void)hiddenTopView:(UIView *)topView{
    
    self.topViewLayoutConstraint.constant = -121.f;
    self.tableViewLayoutConstraint.constant = 64.f;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    isView = NO;

    
}
-(void)showTopView:(UIView *)topView withConstant:(CGFloat)constant{
    
    if (isView == YES) {
        return;
    }
    [self.view bringSubviewToFront:self.topView];
    [self.view bringSubviewToFront:self.navbar];
    self.topViewLayoutConstraint.constant = 64.f;
    self.tableViewLayoutConstraint.constant = constant ;
    
    [UIView animateWithDuration:0.5 animations:^{
//        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];

    } completion:^(BOOL finished) {
//            [self.view layoutIfNeeded];
    }];
    
    isView = YES;
}
-(void)topviewBackToOriginalPosition{
    self.tableViewLayoutConstraint.constant = 249.f;
    self.tableView.contentOffset = CGPointZero;
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}
@end
