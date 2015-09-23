//
//  ShopStyleViewController.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/4.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "ShopStyleViewController.h"
#import "ShopkeeperMessageViewController.h"

@interface ShopStyleViewController (){
    NSString * _type;
}

@end

@implementation ShopStyleViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter]postNotificationName:HIDDEN_TABBAR object:@"1"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.commodityBtn.selected = YES;
    _type = @"20";
    self.navbar.titleLabel.text = @"新开店铺";
    self.nextStep.layer.masksToBounds =YES;
    self.nextStep.layer.borderColor = UIColorFromRGB(0xc61f2e).CGColor;
    self.nextStep.layer.borderWidth = 1.0f;
    self.nextStep.layer.cornerRadius = 5;
    
    self.productImg.userInteractionEnabled = YES;
    self.productLabel.userInteractionEnabled = YES;
    self.serveImg.userInteractionEnabled = YES;
    self.serveLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer * productImgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commodityClick:)];
    [self.productImg addGestureRecognizer:productImgTap];
    UITapGestureRecognizer * productLabelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commodityClick:)];
    [self.productLabel addGestureRecognizer:productLabelTap];
    UITapGestureRecognizer * serveImgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(serviceClick:)];
    [self.serveImg addGestureRecognizer:serveImgTap];
    UITapGestureRecognizer * serveLabelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(serviceClick:)];
    [self.serveLabel addGestureRecognizer:serveLabelTap];

    
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
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)commodityClick:(id)sender {
    
    self.commodityBtn.selected = YES;
    self.serviceBtn.selected = NO;
    _type = @"20";
    
}

- (IBAction)serviceClick:(id)sender {
    
    self.serviceBtn.selected = YES;
    self.commodityBtn.selected = NO;
    _type = @"10";
}

- (IBAction)nextStep:(id)sender {
    if (_type == nil) {
        [self showAlertViewWith:@"请选择店铺类型"];
        return;
    }
    ShopkeeperMessageViewController *view = [[ShopkeeperMessageViewController alloc]init];
    view.type = _type;
    [self.navigationController pushViewController:view
                                         animated:YES];
}
@end
