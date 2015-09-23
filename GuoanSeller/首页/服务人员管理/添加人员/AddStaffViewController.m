//
//  AddStaffViewController.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/6.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "AddStaffViewController.h"
#import "AddStaffTableViewOneCell.h"
#import "AddStaffTableViewTwoCell.h"
#import "PersonTimeManagerViewController.h"
#import "ZLPhoto.h"
#import "DateModel.h"
#import "CommonFunc.h"

@interface AddStaffViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextFieldDelegate>{
    UIImage *_selectImage;
    NSArray *_dateArray;
}

@end

@implementation AddStaffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [ELTRefreshSingleton refreshIsOK].state = NO;
    if ([_tag isEqualToString:@"modify"]) {
        self.navbar.titleLabel.text = @"编辑人员";
    }else{
        self.navbar.titleLabel.text = @"添加人员";
        _personModel = [[AddPersonModel alloc]init];
    }
    self.managerTimeBtn.layer.cornerRadius = 5.0;
    self.navbar.homebtn.hidden = YES;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(SCREENWIDTH - 52, 30, 40, 30);
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navbar addSubview:rightBtn];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat cellHeight;
    switch (indexPath.row) {
        case 0:
            cellHeight = 142;
            break;
        case 1:
            cellHeight = 310;
        default:
            break;
    }
    return cellHeight;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        AddStaffTableViewOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddStaffTableViewOneCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"AddStaffTableViewOneCell" owner:self options:nil]firstObject];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage)];
        cell.picImage.userInteractionEnabled = YES;
        [cell.picImage addGestureRecognizer:tap];
        
        if ([_tag isEqualToString:@"modify"]) {
            
            if (_personModel.selectPhoto) {
                cell.picImage.image = _personModel.selectPhoto.thumbImage;
            }else{
                
                [cell.picImage sd_setImageWithURL:[NSURL URLWithString:_personModel.photo]];
            }
        }else{
            
            if (_personModel.selectPhoto) {
                cell.picImage.image = _personModel.selectPhoto.thumbImage;
            }
            
        }
        return cell;
        
    }else{
        
        AddStaffTableViewTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddStaffTableViewTwoCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"AddStaffTableViewTwoCell" owner:self options:nil]firstObject];
        }
        cell.ageField.delegate = self;
        [cell.button addTarget:self action:@selector(buttonclick) forControlEvents:UIControlEventTouchUpInside];
        if ([_tag isEqualToString:@"modify"]) {
            cell.nameField.text = _personModel.name;
            cell.telField.text = _personModel.mobile;
            cell.ageField.text = _personModel.content_birthday;
            cell.IDCardField.text = _personModel.idcard_no;
            cell.addressField.text = _personModel.content_place;
            cell.workAge.text = _personModel.content_age;
            cell.describeTextView.text = _personModel.content_desc;
            if (_personModel.content_desc == NULL || [_personModel.content_desc isEqualToString:@""]) {
                cell.describeLabel.hidden = NO;
            }else{
                cell.describeLabel.hidden = YES;
            }
            
        }
        return cell;
        
    }
    
}

-(void)buttonclick{
    
    [self.view endEditing:YES];
    _bottomView.hidden = NO;
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    _bottomView.hidden = YES;
    return YES;
}

#pragma mark - 出生年月日   确定点击事件
- (IBAction)sureClick:(id)sender {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *prettyVersion = [dateFormat stringFromDate:_datePicker.date];
    _bottomView.hidden = YES;
    
    AddStaffTableViewTwoCell *cell = (AddStaffTableViewTwoCell *)[self.bgTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.ageField.text = prettyVersion;
}

#pragma mark - 出生年月日   取消点击事件
- (IBAction)cancelClick:(id)sender {
    
    _bottomView.hidden = YES;
    
}

#pragma mark - 按钮的点击事件
-(void)back:(id)sender{
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"AllArray"];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)rightClick{
    
    if ([_tag isEqualToString:@"modify"]){
        [self editUpload];
    }else{
        [self addUpload];
    }
    [ELTRefreshSingleton refreshIsOK].state = YES;
    
}

-(void)selectImage{
    
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"打开照相机",@"从手机相册获取",nil];
    
    [myActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
}

#pragma mark - actionsheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            [self openCamera];
            break;
        case 1:  //打开本地相册
            [self openLocalPhoto];
            break;
    }
}

- (void)openCamera{
    ZLCameraViewController *cameraVc = [[ZLCameraViewController alloc] init];
    // 拍照最多个数
    cameraVc.maxCount = 1;
    [cameraVc showPickerVc:self];
    __weak typeof(self) weakSelf = self;
    cameraVc.callback = ^(NSArray *cameras){
        
        _personModel.selectPhoto = [cameras firstObject];
        [weakSelf.bgTable reloadData];
        
        [self uploadImage];
        
    };
    
}

- (void)openLocalPhoto{
    
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    // 最多能选3张图片
    pickerVc.maxCount = 1;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    [pickerVc showPickerVc:self];
    
    __weak typeof(self) weakSelf = self;
    pickerVc.callBack = ^(NSArray *assets){
        
        _personModel.selectPhoto = [assets firstObject];
        [weakSelf.bgTable reloadData];
        [self uploadImage];
        
    };
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


- (IBAction)managerTime:(id)sender {
    
    [self.indicator setIndicatorType:ActivityIndicatorLogin];
    [self.indicator startAnimatingActivit];
    [ELRequestSingle getDateWithRequest:^(BOOL sucess, id objc) {
        _dateArray = objc;
        PersonTimeManagerViewController *view = [[PersonTimeManagerViewController alloc]init];
        view.shopId = _shopId;
        view.dateArray = objc;
        view.peopleID = _personID;
        [self createDatabase:objc];
        [self.indicator LoadSuccess];
        [self.navigationController pushViewController:view animated:YES];
    } andShoppe_id:_shopId];
    
}

-(void)createDatabase:(NSArray *)array{
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"AllArray"]) {
        return;
    }
    
    NSMutableArray *allArray = [NSMutableArray array];
    [[NSUserDefaults standardUserDefaults]setObject:allArray forKey:@"AllArray"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

-(void)uploadImage{
    
    self.indicator.frame = CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT);
    [self.indicator setIndicatorType:ActivityIndicatorLogin];
    [self.indicator startAnimatingActivit];
        UIImage * modify_image;
//        // 判断类型来获取Image
        ZLPhotoAssets *asset = _personModel.selectPhoto;
        if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
            modify_image = asset.thumbImage;
        }else if([asset isKindOfClass:[UIImage class]]){
            modify_image = (UIImage *)asset;
        }else if ([asset isKindOfClass:[ZLCamera class]]){
            modify_image = [asset thumbImage];
        }
    
    [ELHttpRequestOperation getTokenAndTime];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",HTTP,@"&method=save&app_com=com_appcorpcenter&task=uploadimg"];
    ELHttpRequestOperation *sharedClient = nil;
    sharedClient = [ELHttpRequestOperation manager];
    [sharedClient setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [sharedClient setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [[sharedClient responseSerializer] setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [sharedClient POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(modify_image, 1.0) name:@"content_img_1" fileName:@"content_img_1.jpg"  mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        JSONDecoder * json = [[JSONDecoder alloc]init];
        NSDictionary * dic1 = [json objectWithData:responseObject];
        if ([[dic1 objectForKey:@"status"] integerValue] == 1) {
            [self.indicator LoadSuccess];
            NSArray *array = [dic1 objectForKey:@"datalist"];
            _personModel.photo = [array firstObject];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

-(BOOL)judgeIsValide{
    
    AddStaffTableViewTwoCell *cell = (AddStaffTableViewTwoCell*)[self.bgTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    if (_personModel.photo == NULL || [_personModel.photo isEqualToString:@""]) {
        
        [self showAlertViewWith:@"头像不能为空"];
        return NO;
        
    }else if ([cell.nameField.text isEqualToString:@""]) {
        
        [self showAlertViewWith:@"姓名不能为空"];
        return NO;
        
    }else if ([cell.ageField.text isEqualToString:@""]){
        
        [self showAlertViewWith:@"年龄不能为空"];
        return NO;
        
    }else if ([cell.IDCardField.text isEqualToString:@""]){
        
        [self showAlertViewWith:@"身份证号不能为空"];
        return NO;
        
    }else if (![self validateIdentityCard:cell.IDCardField.text]){
        
        [self showAlertViewWith:@"请输入正确的身份证号"];
        return NO;
        
    }else if ([cell.addressField.text isEqualToString:@""]){
        
        [self showAlertViewWith:@"籍贯不能为空"];
        return NO;
        
    }else if ([cell.telField.text isEqualToString:@""]){
        
        [self showAlertViewWith:@"手机号不能为空"];
        return NO;
        
    }else if (![self validateMobile:cell.telField.text]){
        
        [self showAlertViewWith:@"请输入正确的手机号"];
        return NO;
        
    }

    return YES;
}

-(NSString *)validateArray{
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"AllArray"]];
    NSDictionary *dateDic;
    int i = 0;
    for (;i<array.count; i++) {
        dateDic = [array objectAtIndex:i];
        NSArray *dayArray = [dateDic objectForKey:@"day"];
        if (!dayArray.count) {
            [array removeObject:dateDic];
            i = 0;
        }
    }
    NSString *string = [array JSONString];
    NSString *base = [CommonFunc base64StringFromText:string];
    return base;
}

-(void)editUpload{
    
    if (![self judgeIsValide]) {
        return;
    }
    AddStaffTableViewTwoCell *cell = (AddStaffTableViewTwoCell*)[self.bgTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    NSString *base = [self validateArray];
    
    [self.indicator setIndicatorType:ActivityIndicatorLogin];
    [self.indicator startAnimatingActivit];
    [ELRequestSingle editShopPersonWithRequest:^(BOOL sucess, id objc) {
        [self.indicator LoadSuccess];
        [self showAlertViewWith:objc];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"AllArray"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"modifyStaff"];
        [self.navigationController popViewControllerAnimated:YES];
    } andPeson_id:_personID andEshop_id:_personModel.eshop_id andName:cell.nameField.text andContent_birthday:cell.ageField.text andIdcard_no:cell.IDCardField.text andContent_place:cell.addressField.text andMobile:cell.telField.text andContent_age:[cell.workAge.text isEqualToString:@""]?@"0":cell.workAge.text andContent_desc:[cell.describeTextView.text isEqualToString:@""]?@"":cell.describeTextView.text andImg:_personModel.photo andSchedule:base];
    
}

-(void)addUpload{
    
    if (![self judgeIsValide]) {
        return;
    }
    AddStaffTableViewTwoCell *cell = (AddStaffTableViewTwoCell*)[self.bgTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    NSString *base = [self validateArray];
    
    [self.indicator setIndicatorType:ActivityIndicatorLogin];
    [self.indicator startAnimatingActivit];
    [ELRequestSingle addShopPersonWithRequest:^(BOOL sucess, id objc) {
        
        [self.indicator LoadSuccess];
        [self showAlertViewWith:objc];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"AllArray"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"modifyStaff"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } andEshop_id:_shopId andName:cell.nameField.text andContent_birthday:cell.ageField.text andIdcard_no:cell.IDCardField.text andContent_place:cell.addressField.text andMobile:cell.telField.text andContent_age:[cell.workAge.text isEqualToString:@""]?@"0":cell.workAge.text andContent_desc:[cell.describeTextView.text isEqualToString:@""]?@"":cell.describeTextView.text andImg:_personModel.photo andSchedule:base];
    
}


//身份证号
-(BOOL)validateIdentityCard: (NSString *)identityCard
{
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

//手机号码验证
-(BOOL)validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

@end
