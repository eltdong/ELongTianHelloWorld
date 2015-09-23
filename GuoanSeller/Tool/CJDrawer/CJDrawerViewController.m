//
//  CJDrawerViewController.m
//  TangRen
//
//  Created by 易龙天 on 15/6/15.
//  Copyright (c) 2015年 易龙天. All rights reserved.
//

#import "CJDrawerViewController.h"
#import "Const.h"
#define CELL_TAG 5555
@interface CJDrawerViewController (){
    ScreenDetailViewController * screenDetailVC;
}
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, strong) NSMutableArray * imgArr;
@property (nonatomic, strong) NSString * url;


@end

@implementation CJDrawerViewController
NSInteger cell_tag;
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [screenDetailVC.view removeFromSuperview];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _url = @"";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.deleteBtn.layer.cornerRadius = 5;
    self.view.backgroundColor = [UIColor clearColor];
    
    
    //分割线
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //滚动条
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.dataArr = [NSMutableArray array];
    self.imgArr = [NSMutableArray arrayWithObjects:@"screen_brand",@"screen_type",@"screen_price",@"screen_brand",@"screen_brand",@"screen_type",@"screen_type",@"screen_type", nil];
    
    [self downRequest];
}
- (void)downRequest{
    
    
    [ELRequestSingle screenRequestWithBlock:^(BOOL sucess, id objc) {
        _dataArr = objc;
        [_mainTableView reloadData];
    } andAuto_code:@"100210001000"];
}


//上下拉
//    self.mainTableView.bounces = NO;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CJDrawerVCTableViewCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CJDrawerVCTableViewCell" owner:self options:nil]lastObject];
    BJObject * object = [_dataArr objectAtIndex:indexPath.row];
    cell.img.image = [UIImage imageNamed:[self.imgArr objectAtIndex:indexPath.row]];
    cell.title.text = object.content_name;
    cell.tag = indexPath.row + CELL_TAG;
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    screenDetailVC = [[ScreenDetailViewController alloc]init];
    screenDetailVC.delagate = self;
    BJObject * object = [self.dataArr objectAtIndex:indexPath.row];
    screenDetailVC.subArr = object.picture;
    [screenDetailVC.view setFrame:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT)]; //notice this is OFF screen!
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [screenDetailVC.view setFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)]; //notice this is ON screen!
    [UIView commitAnimations];
    [self.view addSubview:screenDetailVC.view];
    cell_tag = indexPath.row + CELL_TAG;
}
- (void)popView:(BJObject *)obj{
    [screenDetailVC.view setFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)]; //notice this is ON screen!
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [screenDetailVC.view setFrame:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT)]; //notice this is OFF screen!
    [UIView commitAnimations];
    if (obj != nil) {
        BJObject * object = obj;
        CJDrawerVCTableViewCell * cell = (CJDrawerVCTableViewCell *)[_mainTableView viewWithTag:cell_tag];
        cell.name.text = object.content_name;
        cell.name.textColor = UIColorFromRGB(0xfc0c0d);
        NSString * str = [NSString stringWithFormat:@"&%@=%@",object.vars,object.content_value];
        if (_url == nil) {
            _url = str;
        }else{
            _url = [_url stringByAppendingString:str];
        }
        NSLog(@"%@",_url);
    }
}








- (IBAction)cancleBtnClicked:(id)sender {
    
    [self.delegate cancleBtnClicked:sender];
    [self popAnimation];
}
- (IBAction)OKBtnClicked:(id)sender {
    [self.delegate OKBtnClicked:_url];
    [self popAnimation];
}
- (IBAction)deleteBtnClicked:(id)sender {
    for (int i = 0; i < _dataArr.count; i++) {
        CJDrawerVCTableViewCell * cell = (CJDrawerVCTableViewCell *)[_mainTableView viewWithTag:i + CELL_TAG];
        cell.name.text = @"全部";
        cell.name.textColor = UIColorFromRGB(0x333333);
    }
    _url = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)pushAnimation{
    [self.view setFrame:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT)]; //notice this is OFF screen!
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [self.view setFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)]; //notice this is ON screen!
    [UIView commitAnimations];
    
}
- (void)popAnimation{
    [self deleteBtnClicked:nil];
    [self.view setFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)]; //notice this is OFF screen!
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [self.view setFrame:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT)]; //notice this is ON screen!
    [UIView commitAnimations];

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