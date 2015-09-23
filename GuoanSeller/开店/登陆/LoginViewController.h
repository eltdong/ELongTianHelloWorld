//
//  LoginViewController.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/4.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseViewController.h"
#import "JKCountDownButton.h"

@interface LoginViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITextField *telField;//电话号码

@property (strong, nonatomic) IBOutlet UITextField *codeField;//密码

@property (strong, nonatomic) IBOutlet JKCountDownButton *getCodeBtn;//获取验证码

@property (strong, nonatomic) IBOutlet UIButton *loginBtn;//登陆

- (IBAction)getCode:(id)sender;//获取验证码


- (IBAction)login:(id)sender; //登陆

@end
