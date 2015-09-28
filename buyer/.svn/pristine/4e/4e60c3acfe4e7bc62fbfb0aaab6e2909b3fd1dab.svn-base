//
//  ScreenDetailViewController.m
//  TangRen
//
//  Created by 易龙天 on 15/6/30.
//  Copyright (c) 2015年 易龙天. All rights reserved.
//

#import "ScreenDetailViewController.h"
#define CELL_TAG 8888
@interface ScreenDetailViewController ()

@end
static NSInteger subCell_tag = 0 + CELL_TAG;
@implementation ScreenDetailViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_mainTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _subArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ScreenDetailTableViewCell * cell = [[[NSBundle mainBundle]loadNibNamed:@"ScreenDetailTableViewCell" owner:self options:nil] lastObject];
    BJObject * object = [_subArr objectAtIndex:indexPath.row];
    cell.name.text = object.content_name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    [cell.name setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    cell.name.textColor = UIColorFromRGB(0x999999);
    cell.tag = indexPath.row + CELL_TAG;
    if (cell.tag == subCell_tag) {
        cell.name.textColor = UIColorFromRGB(0xfc0c0d);
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (IBAction)cancleBtnClicked:(id)sender {
    [self.delagate popView:nil];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BJObject * obj = [_subArr objectAtIndex:indexPath.row];
    [self.delagate popView:obj];
    
    ScreenDetailTableViewCell * cell = (ScreenDetailTableViewCell *)[self.mainTableView viewWithTag:subCell_tag];
    cell.name.textColor = UIColorFromRGB(0x999999);
    
    ScreenDetailTableViewCell * cell1 = (ScreenDetailTableViewCell *)[self.mainTableView viewWithTag:indexPath.row + CELL_TAG];
    cell1.name.textColor = UIColorFromRGB(0xfc0c0d);
    
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
