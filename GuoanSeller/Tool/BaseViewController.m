//
//  BaseViewController.m
//  BaoJianIphone
//
//  Created by elongtian on 15-2-11.
//  Copyright (c) 2015年 madongkai. All rights reserved.
//

#import "BaseViewController.h"
#import "IQKeyBoardManager.h"

@interface BaseViewController ()<UIActionSheetDelegate>

@end

@implementation BaseViewController
@synthesize navbar;
@synthesize bottom_logoV;
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDDEN_TABBAR object:@"1"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    if ([[UIDevice currentDevice] systemVersion].floatValue>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    navbar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navbar.delegate = self;
    [self.view addSubview:navbar];
    
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
//    bottom_logoV = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-49, SCREENWIDTH, 49)];
//    bottom_logoV.hidden = YES;
//    bottom_logoV.contentMode = UIViewContentModeCenter;
//    [bottom_logoV setImage:[UIImage imageNamed:@"bottom_bj_icon.png"]];
//    [self.view addSubview:bottom_logoV];
    self.indicator = [[ActivityIndicator alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT) LabelText:@"正在加载..." withdelegate:self withType:ActivityIndicatorDefault andAction:nil];
     [self.view addSubview:self.indicator];
    
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
     
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)downRequest:(NSMutableDictionary *)paraDic{
//    
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - 自定义的自动消失的框
-(void)showAlertViewWith:(NSString *)title{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:title delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange:) userInfo:alertView repeats:NO];
    [alertView show];
}
-(void)timeChange:(NSTimer*)timer{
    
    UIAlertView *promptAlert = (UIAlertView*)[timer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)showActionsheetWithPhoto{
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"打开照相机",@"从手机相册获取",nil];
    
    [myActionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

@end
