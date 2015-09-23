//
//  MyIncomeViewController.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/4.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "MyIncomeViewController.h"
#import "IncomeCurrentTViewController.h"

@interface MyIncomeViewController ()

@end

@implementation MyIncomeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter]postNotificationName:HIDDEN_TABBAR object:@"1"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navbar.titleLabel.text = @"我的收入";
    self.priceLabel.text = [NSString stringWithFormat:@"%ld",_myAccount];
    self.navbar.homebtn.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
 
}


- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)button:(id)sender {
    IncomeCurrentTViewController *view = [[IncomeCurrentTViewController alloc]init];
    [self.navigationController pushViewController:view animated:YES];
    
}
@end
