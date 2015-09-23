//
//  ShopStyleViewController.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/4.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseViewController.h"

@interface ShopStyleViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UIButton *commodityBtn;//商品店铺

@property (strong, nonatomic) IBOutlet UIButton *serviceBtn;//服务店铺

@property (strong, nonatomic) IBOutlet UIButton *nextStep;//下一步
@property (strong, nonatomic) IBOutlet UIImageView *productImg;
@property (strong, nonatomic) IBOutlet UILabel *productLabel;
@property (strong, nonatomic) IBOutlet UIImageView *serveImg;
@property (strong, nonatomic) IBOutlet UILabel *serveLabel;

- (IBAction)commodityClick:(id)sender;

- (IBAction)serviceClick:(id)sender;

- (IBAction)nextStep:(id)sender;

@end
