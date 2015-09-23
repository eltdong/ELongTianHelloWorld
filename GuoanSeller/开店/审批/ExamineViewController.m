//
//  ExamineViewController.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/6.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "ExamineViewController.h"

@interface ExamineViewController ()

@end

@implementation ExamineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navbar.titleLabel.text = @"审批中";
    self.bottomClick.layer.masksToBounds =YES;
    self.bottomClick.layer.borderColor = UIColorFromRGB(0xc61f2e).CGColor;
    self.bottomClick.layer.borderWidth = 1.0f;
    self.bottomClick.layer.cornerRadius = 5;
    self.navbar.backbtn.hidden = YES;
    [self.navbar.homebtn setTitle:@"完成" forState:UIControlStateNormal];
//    [self.navbar.homebtn setBackgroundImage:[UIImage imageNamed:@"delect"] forState:UIControlStateNormal];
    
    [ELTRefreshSingleton refreshIsOK].state = NO;
    NSDate * time = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"申请时间 yyyy年M月d日"];
    self.date.text = [formatter stringFromDate:time];

}

-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)home:(id)sender{
    [ELTRefreshSingleton refreshIsOK].state = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
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

- (IBAction)bottomClick:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"dataArrRemove" object:nil];
    ShopManagementViewController * shop = [[ShopManagementViewController alloc]initWithNibName:@"ShopManagementViewController" bundle:nil];
    shop.shopId = _shop_id;
    shop.isEdit = YES;
    [self.navigationController pushViewController:shop animated:YES];
}
@end
