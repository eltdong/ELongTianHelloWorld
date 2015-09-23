//
//  ShopMessageViewController.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/7.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "ShopMessageViewController.h"
#import "ShopMessageTableViewCell.h"
#import "ExamineViewController.h"
#import "BusinessHoursViewController.h"
#import <AVFoundation/AVFoundation.h>


#define CELL_TAG 85641235789
@interface ShopMessageViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_nameArray;
    NSArray *_detailArray;//detail的内容，后期删除
    
    
    //营业时间的json串
    NSString * baseWeek;
    NSString * baseRest;
    //图片url
    NSString * _imgUrl;
//    //店铺地址
//    NSString * _address;
//    //配送范围
//    NSString * _
    //距月店路程
    NSString * _time;
    NSMutableArray * _dataTime;
    NSMutableArray * _cellArr;
    
}

@end

@implementation ShopMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[ELTDataArr dataArr].dataArr removeAllObjects];
    // Do any additional setup after loading the view from its nib.
    self.navbar.titleLabel.text = @"开店－店铺信息";
    _nameArray = @[@"店铺头像",@"店铺名称",@"营业时间",@"店铺地址",@"配送范围",@"距月店路程"];
    _detailArray = @[@"未填写",@"北京市朝阳区向军南里11号",@"未填写",@"分钟"];
    self.bgTable.scrollEnabled = NO;
    self.bottomBtn.layer.cornerRadius = 5.0;
    self.bottomBtn.layer.masksToBounds =YES;
    self.bottomBtn.layer.borderColor = UIColorFromRGB(0xEFEFF4).CGColor;
    self.bottomBtn.layer.borderWidth = 1.0f;
    self.scale = 100.0/100.0;
//    sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"我的相册", nil];
    //边框颜色
    self.bottomBtn.layer.borderColor = UIColorFromRGB(0xececec).CGColor;
    //边框宽
    self.bottomBtn.layer.borderWidth = 1.0f;
    self.bottomBtn.selected = NO;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 79;
    }else if(indexPath.row == 1){
        return 47;
    }else{
        return 42;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self btnSelect];
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self btnSelect];
    return YES;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"ShopMessageTableViewCell" owner:self options:nil];
    
    if (indexPath.row == 0) {
        ShopMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopMessageTableViewCellFour"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ShopMessageTableViewCell" owner:self options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 1) {
        
        ShopMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopMessageTableViewCellThree"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ShopMessageTableViewCell" owner:self options:nil]objectAtIndex:array.count - 2];
        }
        cell.nameLabel.text = [_nameArray objectAtIndex:indexPath.row-1];
        cell.tag = CELL_TAG;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 2 ) {
        
        
        ShopMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopMessageTableViewCellTwo"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ShopMessageTableViewCell" owner:self options:nil] objectAtIndex:array.count-3];
        }
        cell.detailTextfield.delegate = self;
        cell.nameLabel.text = [_nameArray objectAtIndex:indexPath.row-1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 2) {
            cell.tag = CELL_TAG + 2;
            cell.detailTextfield.placeholder = @"请输入店铺名称";
        }
        return cell;
        
    }else if (indexPath.row == 6) {
        
        
        ELTTimeShopMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ELTTimeShopMessageTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ELTTimeShopMessageTableViewCell" owner:self options:nil] lastObject];
        }
        cell.detailTextfield.delegate = self;
        cell.nameLabel.text = [_nameArray objectAtIndex:indexPath.row-1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tag = CELL_TAG + 6;
        cell.detailTextfield.keyboardType = UIKeyboardTypeNumberPad;
        return cell;
        
    }else{
        
        ShopMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopMessageTableViewCellOne"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ShopMessageTableViewCell" owner:self options:nil]firstObject];
        }
        if (indexPath.row == 5) {
            cell.detailLabel.textColor = [UIColor redColor];
        }
        cell.nameLabel.text = [_nameArray objectAtIndex:indexPath.row-1];
        cell.detailLabel.text = [_detailArray objectAtIndex:indexPath.row - 3];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tag = CELL_TAG + indexPath.row;
        return cell;
    }
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 1){
        [self showActionsheetWithPhoto];
    }else if (indexPath.row == 2){
        
    }else if (indexPath.row == 3){
        BusinessHoursViewController * businessHoursVC = [[BusinessHoursViewController alloc]initWithNibName:@"BusinessHoursViewController" bundle:nil];
        NSMutableArray * arr = [NSMutableArray array];
        [arr addObjectsFromArray:_dataTime];
        businessHoursVC.dataTimeArr = arr;
        businessHoursVC.cellArr = _cellArr;
        businessHoursVC.block = ^(NSMutableArray * timeArr,NSMutableArray * dateArr){
            ShopMessageTableViewCell * cell = (ShopMessageTableViewCell *)[_bgTable viewWithTag:CELL_TAG + 3];
            cell.detailLabel.text = @"已选择";
            NSMutableArray * arr = [NSMutableArray array];
            for (NSDictionary * dic in timeArr) {
                if ([[dic objectForKey:@"weekSelect"] integerValue] == 1) {
                    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"week"],@"week",
                                                     [dic objectForKey:@"close_time"],@"close_time",
                                                     [dic objectForKey:@"open_time"],@"open_time",nil];
                    
                    [arr addObject:dataDic];
                }
            }
            baseWeek = [CommonFunc base64StringFromText:[arr JSONString]];
            _dataTime = [NSMutableArray array];
            [_dataTime addObjectsFromArray:timeArr];
            baseRest = nil;
            _cellArr = dateArr;
            if (dateArr.count > 0) {
                NSMutableArray * arr1 = [NSMutableArray array];
                for (NSString * str in dateArr) {
                    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[self textFieldYear:str],@"date", nil];
                    [arr1 addObject:dic];
                    NSLog(@"%@",[self textFieldYear:str]);
                }
                baseRest = [CommonFunc base64StringFromText:[arr1 JSONString]];
                
            }
            NSLog(@"++%@---%@",[timeArr JSONString],[[NSDictionary dictionaryWithObjectsAndKeys:dateArr,@"date", nil] JSONString]);
            [self btnSelect];
        };
        [self.navigationController pushViewController:businessHoursVC animated:YES];
    }
}

- (void)btnSelect{
    ShopMessageTableViewCell * name_cell = (ShopMessageTableViewCell *)[_bgTable viewWithTag:CELL_TAG + 2];
    ELTTimeShopMessageTableViewCell * time_cell = (ELTTimeShopMessageTableViewCell *)[_bgTable viewWithTag:CELL_TAG + 6];
    if (_imgUrl == nil || (name_cell.detailTextfield.text == nil || [name_cell.detailTextfield.text isEqualToString:@""])|| (time_cell.detailTextfield.text == nil || [time_cell.detailTextfield.text isEqualToString:@""]) || baseWeek == nil) {
        self.bottomBtn.selected = NO;
        [self.bottomBtn setBackgroundColor:UIColorFromRGB(0xececec)];
    }else{
        self.bottomBtn.selected = YES;
        [self.bottomBtn setBackgroundColor:UIColorFromRGB(0xC61F2E)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    [[ELTDataArr dataArr].dataArr removeAllObjects];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - 提交
- (IBAction)bottomClick:(id)sender {
    
    if(self.bottomBtn.selected){
        ShopMessageTableViewCell * name_cell = (ShopMessageTableViewCell *)[_bgTable viewWithTag:CELL_TAG + 2];
        ELTTimeShopMessageTableViewCell * time_cell = (ELTTimeShopMessageTableViewCell *)[_bgTable viewWithTag:CELL_TAG + 6];
        if (_imgUrl == nil) {
            [self showAlertViewWith:@"请选择店铺头像!"];
            return;
        }
        if (name_cell.detailTextfield.text == nil || [name_cell.detailTextfield.text isEqualToString:@""]) {
            [self showAlertViewWith:@"请输入店铺名称!"];
            return;
        }
        if (time_cell.detailTextfield.text == nil || [time_cell.detailTextfield.text isEqualToString:@""]) {
            [self showAlertViewWith:@"请输入距月店距离!"];
            return;
        }
        if (baseWeek == nil) {
            [self showAlertViewWith:@"请选择营业时间!"];
            return;
        }
        
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     name_cell.detailTextfield.text,@"eshop[name]",
                                     _type,@"eshop[type]",
                                     _name,@"eshop[applicant_name]",
                                     _ID,@"eshop[applicant_idcard_no]",
                                     _imgOne,@"eshop[applicant_idcard_pic]",
                                     _imgTwo,@"eshop[applicant_idcard_backpic]",
                                     _imgUrl,@"eshop[content_img]",
                                     [NSNumber numberWithInt:[time_cell.detailTextfield.text intValue]],@"distance[time]",
                                     nil];
        
        NSLog(@"%@",dic);
        
        [self.indicator setIndicatorType:ActivityIndicatorLogin];
        [self.indicator startAnimatingActivit];
        [ELRequestSingle addEshopRequestWithBlock:^(BOOL sucess, id objc) {
            [self.indicator LoadSuccess];
            if (sucess) {
                ExamineViewController *view = [[ExamineViewController alloc]init];
                view.shop_id = objc;
                [self.navigationController pushViewController:view animated:YES];
            }else{
                [self showAlertViewWith:objc];
            }
        } andData:dic andWeek:baseWeek andRest:baseRest];
    }
}
#pragma mark - 替换年月日
- (NSString *)textFieldYear:(NSString *)str{
    str = [str stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    str = [str stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
    str = [str stringByReplacingOccurrencesOfString:@"日" withString:@""];
    return str;
}
#pragma mark - 替换空格
- (NSString *)textFieldSpeca:(NSString *)str{
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}
#pragma mark  选择照片
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            [self showAlertViewWith:@"相机权限受限"];
        }
        else{
            [self openCamera];
        }
    }
    else if(buttonIndex == 1)
    {
        [self openPics];
    }
}
// 打开相机
- (void)openCamera {
    // UIImagePickerControllerCameraDeviceRear 后置摄像头
    // UIImagePickerControllerCameraDeviceFront 前置摄像头
    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!isCamera) {
        NSLog(@"没有摄像头");
        [self showAlertViewWith:@"抱歉,您的设备不具备拍照功能!"];
        return ;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    // 编辑模式
    imagePicker.allowsEditing = YES;
    
    [self  presentViewController:imagePicker animated:YES completion:^{
    }];
}
// 打开相册
- (void)openPics {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self  presentViewController:imagePicker animated:YES completion:^{
    }];
}

// 选中照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"%@", info);
    //    [self.indicator startAnimatingActivit];
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        //        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // present the cropper view controller
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width*self.scale) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^{
        }];
    }];
}
#pragma mark VPImageCropperDelegate
//图片界面点击确定
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.selfimage = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
        UIImage * modify_image = [UIImage fixOrientation:self.selfimage];
        ShopMessageTableViewCell * cell = (ShopMessageTableViewCell *)[self.bgTable viewWithTag:CELL_TAG];
        cell.detailImage.image = modify_image;
        NSString * imgName = @"content_img_1";
        CGSize imagesize = modify_image.size;
        imagesize.height =100;
        imagesize.width =100;
        //对图片大小进行压缩--
        modify_image = [self imageWithImage:modify_image scaledToSize:imagesize];
        
        [ELHttpRequestOperation getTokenAndTime];
        NSString * url = [NSString stringWithFormat:@"%@%@",HTTP,@"&method=save&app_com=com_appcenter&task=uploadimg"];
        ELHttpRequestOperation *sharedClient = nil;
        [self.indicator setIndicatorType:ActivityIndicatorLogin];
        [self.indicator startAnimatingActivit];
        sharedClient = [ELHttpRequestOperation manager];
        [sharedClient setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        [sharedClient setRequestSerializer:[AFHTTPRequestSerializer serializer]];
        [[sharedClient responseSerializer] setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
        [sharedClient POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:UIImagePNGRepresentation(modify_image) name:imgName fileName:[NSString stringWithFormat:@"%@.png",imgName]  mimeType:@"image/png"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
            [self.indicator LoadSuccess];
            JSONDecoder * json = [[JSONDecoder alloc]init];
            NSDictionary * dic1 = [json objectWithData:responseObject];
            NSLog(@"%@",[dic1 objectForKey:@"msg"]);
            if([[dic1 objectForKey:@"status"] integerValue] == 1){
                _imgUrl = [dic1 objectForKey:@"datalist"][0];
                [self btnSelect];
            }else{
                [self showAlertViewWith:[dic1 objectForKey:@"msg"]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.indicator LoadFailed];
            [self showAlertViewWith:error.localizedDescription];
        }];

    }];
}
//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
//图片界面点击取消
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
