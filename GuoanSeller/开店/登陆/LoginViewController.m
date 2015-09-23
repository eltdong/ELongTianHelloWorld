//
//  LoginViewController.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/4.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//


#define kAlphaNum   @"0123456789"
#define ELTNumAndWord @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#import "LoginViewController.h"
#import "ShopListViewController.h"
#import "JKCountDownButton.h"
@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) UITextField *currentSelctedTextField;
@end

@implementation LoginViewController
#pragma mark - viewWillAppear viewDidLoad
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter]postNotificationName:HIDDEN_TABBAR object:@"1"];
    //清空输入框的内容
//    self.telField.text = @"";
//    self.codeField.text = @"";
//    static NSInteger i=0;
//    if (i>0) {
//        
//        [self.getCodeBtn backOnTheFirstLevelInterface];
//    }
//    i++;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navbar.hidden = YES;
    // Do any additional setup after loading the view from its nib.
    self.getCodeBtn.layer.masksToBounds =YES;
    self.getCodeBtn.layer.borderColor = UIColorFromRGB(0xf1f1f1).CGColor;
    self.getCodeBtn.layer.borderWidth = 1.0f;
    self.getCodeBtn.layer.cornerRadius = 5;
    [ELTRefreshSingleton refreshIsOK].state = YES;
    self.view.backgroundColor = [UIColor whiteColor];
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
#pragma mark - 跳转
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 手机号限制位数
- (IBAction)textField:(id)sender {
    UITextField * tf = sender;
    if (tf.tag == 10) {
        [self modifyPhoeNum:tf];
        self.currentSelctedTextField = tf;
    }
    else if(tf.tag ==11)
    {
        //        [self modifyVertificationCode:tf];
        self.currentSelctedTextField = tf;
    }
}

#pragma mark - 获取验证码
- (IBAction)getCode:(id)sender {
    [self.currentSelctedTextField resignFirstResponder];
    if ([self.telField.text length]<11) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号长度不够" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show]; 
    }
    else if ([self  isMobileNumber:self.telField.text] == NO){
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else{
        [self.indicator setIndicatorType:ActivityIndicatorLogin];
      [self.indicator startAnimatingActivit];
    [ELRequestSingle loginWithRequest:^(BOOL sucess, id objc) {
        [self.indicator LoadSuccess];
        if (sucess) {
            BJObject * object = (BJObject *)objc;
            [self showAlertViewWith:object.msg];//提示发送成功
            self.getCodeBtn.enabled = NO;
            //button type要 设置成custom 否则会闪动
            [self.getCodeBtn startWithSecond:120];
            
            [self.getCodeBtn didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
                NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
                return title;
            }];
            [self.getCodeBtn didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                countDownButton.enabled = YES;
                return @"重新获取";
            }];

        }
        else{
            [self showAlertViewWith:objc];
        }
      } andID:self.telField.text];
    }
}

#pragma mark - 判断号码是否合法
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
        /**
         * 手机号码
         * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
         * 联通：130,131,132,152,155,156,185,186
         * 电信：133,1349,153,180,189
         */
        //    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
        /**
         10         * 中国移动：China Mobile
         11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
         12         */
        //    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
        /**
         15         * 中国联通：China Unicom
         16         * 130,131,132,152,155,156,185,186
         17         */
        NSString * CU = @"^1(3[0-9]|5[0-9]|8[0-9]|7[0-9])\\d{8}$";
        /**
         20         * 中国电信：China Telecom
         21         * 133,1349,153,180,189
         22         */
        //    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
        /**
         25         * 大陆地区固话及小灵通
         26         * 区号：010,020,021,022,023,024,025,027,028,029
         27         * 号码：七位或八位
         28         */
        // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
        
        //    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        //    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
        NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
        //    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
        
        if (
            //        ([regextestmobile evaluateWithObject:mobileNum] == YES)
            //        || ([regextestcm evaluateWithObject:mobileNum] == YES)
            //        || ([regextestct evaluateWithObject:mobileNum] == YES)
            ([regextestcu evaluateWithObject:mobileNum] == YES))
        {
            return YES;
        }
        else
        {
            return NO;
        }
}
#pragma mark -点击登陆
- (IBAction)login:(id)sender {
    [self downToken];//获取token
}

#pragma mark - 获取token值
- (void)downToken{
    //时间戳
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970];//秒
    NSString * recordtimeStr = [NSString stringWithFormat:@"%llu",recordTime]; 
    [[NSUserDefaults standardUserDefaults]setObject:recordtimeStr forKey:@"time"];
    NSLog(@"%@",NSUserDefaults_Time);
    //设备号  一个app唯一
    NSString *idfv =[[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString * url = [NSString stringWithFormat:@"%@&method=createToken&time=%@&client=2&device=%@",HTTP_SUB,NSUserDefaults_Time,idfv];
//    http://192.168.1.166/zxga/app/index.php?com=com_appService&method=createToken&time=1439538851&client=1&device=ZcUULGieGH
    
    NSLog(@"获取token值 获取token值 %@",url);
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSLog(@"获取token值 %@",dic);
        if ([[dic objectForKey:@"status"]integerValue] == 1) {
            NSString *token = [[dic objectForKey:@"data"] objectForKey:@"token"];
            [[NSUserDefaults standardUserDefaults]setObject:token forKey:@"token"];
            
            [self login];//登陆
        }
        else{
           [ self showAlertViewWith:[dic objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        [self.indicator LoadFailed];
        [self showAlertViewWith:error.localizedDescription];
    }];
}
#pragma mark  - 验证成功 登陆
- (void)login{

    
    if (NSUserDefaults_Member_id  != nil) {
        [UserLoginInfoManager loginmanager].state = YES;
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.codeField resignFirstResponder];
        [self.indicator setIndicatorType:ActivityIndicatorLogin];
        [self.indicator startAnimatingActivit];
        [ELRequestSingle loginWithRequest:^(BOOL sucess, id objc) {
            [self.indicator LoadSuccess];
//            BJObject * object = (BJObject *)objc;
//            [self showAlertViewWith:object.msg];//提示发送成功
            if (sucess) {
                [UserLoginInfoManager loginmanager].state = YES;
                NSLog(@"%@",self.presentationController);
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else{
                 [self showAlertViewWith:objc];
            }
        } andID:self.telField.text  andVerificationCode:self.codeField.text];
    }

}
#pragma mark - 手机号提示
-(void)modifyPhoeNum:(UITextField *)tf{
     if ([tf.text length]>=12) {
        NSString * str = tf.text;
        tf.text =[str substringToIndex:11];
         
         UIAlertView *  alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"最多输入11位手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
         [alert show];
    }
}


//只可以输入数字的方法
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSCharacterSet *cs;
//    NSString *filtered;
//    if (textField.tag == 10) {
//        cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
//        filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
//     }
//    else
//    {
//        cs = [[NSCharacterSet characterSetWithCharactersInString:ELTNumAndWord] invertedSet];
//        filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
//        
//    } 
//    BOOL canChange = [string isEqualToString:filtered];
//    return canChange;
//}@end

//获取时间戳
-(NSString *)currentTimeStamp{
    //    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    //    NSTimeInterval a=[dat timeIntervalSince1970];
    //    return  [NSString stringWithFormat:@"%f",a];//转为字符型
    //时间戳
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970];//秒
    NSString * recordtimeStr = [NSString stringWithFormat:@"%llu",recordTime];
    [[NSUserDefaults standardUserDefaults]setObject:recordtimeStr forKey:@"time"];
    return recordtimeStr;
}
//获取当前设备号
-(NSString *)currentDevice{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}
@end

