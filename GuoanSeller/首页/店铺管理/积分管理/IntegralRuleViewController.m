//
//  IntegralRuleViewController.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/8.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "IntegralRuleViewController.h"

@interface IntegralRuleViewController ()

@end

@implementation IntegralRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navbar.titleLabel.text =@"积分规则";
    [self.navbar.homebtn setTitle:@"刷新" forState:UIControlStateNormal];
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
