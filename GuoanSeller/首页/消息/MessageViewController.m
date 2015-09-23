//
//  MessageViewController.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/5.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"

@interface MessageViewController ()

@end

@implementation MessageViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:HIDDEN_TABBAR object:@"0"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navbar.titleLabel.text = @"系统消息";
    self.navbar.backbtn.hidden = YES;
    
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 74;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    
//    return 5;
//    
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableViewCell"];
//    if (!cell) {
//        cell = [[[NSBundle mainBundle]loadNibNamed:@"MessageTableViewCell" owner:self options:nil]firstObject];
//    }
//    if (indexPath.row % 2 == 0) {
//        cell.stateLabel.text = @"申请退款";
//        cell.stateLabel.textColor = UIColorFromRGB(0x038c00);
//    }
//    return cell;
//    
//}

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
