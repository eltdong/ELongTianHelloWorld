//
//  SettingViewController.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/5.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"
#import "AccountViewController.h"
#import "NewsViewController.h"
#import "SettingTwoCell.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_nameArray;
}

@end

@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:HIDDEN_TABBAR object:@"0"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navbar.titleLabel.text = @"设置";
    _nameArray = @[@[@"帐号管理",@"新消息通知"],@[@"我的商店"],@[@"关于我们",@"帮助与评价",@"求评价"],@[@""]];
    self.navbar.backbtn.hidden = YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        return 17;
    }
    return 13;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [_nameArray objectAtIndex:section];
    return array.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _nameArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section != 3) {
        
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SettingTableViewCell" owner:self options:nil]firstObject];
        }
        cell.nameLabel.text = [[_nameArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        if(indexPath.section == 2 && indexPath.row == 2){
            cell.arrowImage.hidden = YES;
        }
        return cell;
        
    }else{
        
        SettingTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTwoCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SettingTwoCell" owner:self options:nil]firstObject];
        }
        return cell;

    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            AccountViewController *view = [[AccountViewController alloc]init];
            [self.navigationController pushViewController:view animated:YES];
        }else if (indexPath.row == 1){
            NewsViewController *view = [[NewsViewController alloc]init];
            [self.navigationController pushViewController:view animated:YES];
        }
    }
    
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
