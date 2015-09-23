//
//  ShopkeeperMessageViewController.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/4.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "ShopkeeperMessageViewController.h"
#import "ShopKeeperOneTableViewCell.h"

#import "ShopMessageViewController.h"

#import "UIImage+Expland.h"
#import "FileUtil.h"

#define kPhotoName              @"headImage.jpg"
#define kImageCachePath         @"imagecache"
#define kImageBinary            @"imageBinary.plist"
#define kImageBlinarykey        @"HeadImage"

#define ORIGINAL_MAX_WIDTH 640.0f


@interface ShopkeeperMessageViewController ()<UITableViewDataSource,UITableViewDelegate,ShopKeeperOneTableViewCellDelegate>{
    ShopKeeperOneTableViewCell *cell;
    NSInteger imgTag;
    UIActionSheet * sheet;
    
    NSString * img_one;
    NSString * img_two;
}

@end

@implementation ShopkeeperMessageViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter]postNotificationName:HIDDEN_TABBAR object:@"1"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.navbar.titleLabel.text = @"开店－店主信息";

    
    self.scale = 100.0/158.0;
    sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机",@"从手机相册获取", nil];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 550;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    cell = [tableView dequeueReusableCellWithIdentifier:@"ShopKeeperOneTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ShopKeeperOneTableViewCell" owner:self options:nil]firstObject];
    }
    cell.delegate = self;
    cell.imageOne.userInteractionEnabled = YES;
    cell.imageOne.tag = 1;
    cell.imageTwo.userInteractionEnabled = YES;
    cell.imageTwo.tag = 2;
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTap:)];
    [cell.imageOne addGestureRecognizer:tap1];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTap:)];
    [cell.imageTwo addGestureRecognizer:tap2];
    
    return cell;
    
}
- (void)imgTap:(UIGestureRecognizer *)tap{
    if (tap.view.tag == 1) {
        imgTag = 1;
        
    }else{
        imgTag = 2;
    }
    [sheet showInView:self.view];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        //设置image的尺寸
        // present the cropper view controller
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width*self.scale) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^{
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
#pragma mark VPImageCropperDelegate
//图片界面点击确定
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.selfimage = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
        UIImage * modify_image = [UIImage fixOrientation:self.selfimage];
        NSString * imgName;
        if(imgTag == 1){
            cell.imageOne.image = modify_image;
            imgName = @"content_img_1";
        }else{
            cell.imageTwo.image = modify_image;
            imgName = @"content_img_2";
        }
        CGSize imagesize = modify_image.size;
        imagesize.height =100;
        imagesize.width =158;
        //对图片大小进行压缩--
        modify_image = [self imageWithImage:modify_image scaledToSize:imagesize];
        
        [ELHttpRequestOperation getTokenAndTime];
        [self.indicator setIndicatorType:ActivityIndicatorLogin];
        [self.indicator startAnimatingActivit];
        NSString * url = [NSString stringWithFormat:@"%@%@",HTTP,@"&method=save&app_com=com_appcenter&task=uploadimg"];
        ELHttpRequestOperation *sharedClient = nil;
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
            if (imgTag == 1) {
                img_one = [dic1 objectForKey:@"datalist"][0];
            }else{
                img_two = [dic1 objectForKey:@"datalist"][0];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.indicator LoadFailed];
            [self showAlertViewWith:error.localizedDescription];
        }];

    }];
}
//图片界面点击取消
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
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
    [[ELTDataArr dataArr].dataArr removeAllObjects];
}

#pragma cell的代理
-(void)bottomClick:(UIButton *)button{
    
//    
    if ( [self textFieldSpeca:cell.nameFiled.text ] == nil || [[self textFieldSpeca:cell.nameFiled.text ] isEqualToString:@""]) {
        [self showAlertViewWith:@"请填写真实姓名!"];
        return;
    }
    if ( [self textFieldSpeca:cell.IDCardField.text ] == nil || [[self textFieldSpeca:cell.IDCardField.text ] isEqualToString:@""]) {
        [self showAlertViewWith:@"请填写身份证号!"];
        return;
    }else if(![self validateIdentityCard:[self textFieldSpeca:cell.IDCardField.text]]){
        [self showAlertViewWith:@"请填写正确的身份证号!"];
        return;
    }
    if (img_one == nil || img_two == nil) {
        [self showAlertViewWith:@"请选择证件照!"];
        return;
    }
    
    ShopMessageViewController *view = [[ShopMessageViewController alloc]init];
    view.imgOne = img_one;
    view.imgTwo = img_two;
    view.type = _type;
    view.name = [self textFieldSpeca:cell.nameFiled.text ];
    view.ID = [self textFieldSpeca:cell.IDCardField.text];
    [self.navigationController pushViewController:view animated:YES];

//    ShopMessageViewController *view = [[ShopMessageViewController alloc]init];
//    [self.navigationController pushViewController:view animated:YES];
//    NSLog(@"sdhfiudhfhf");
}
//身份证号
-(BOOL)validateIdentityCard: (NSString *)identityCard
{
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSUInteger length = textField.text.length;
    if (length >= 18 && string.length >0)
    {
        return NO;
    }
    return YES;
}
#pragma mark - 替换空格
- (NSString *)textFieldSpeca:(NSString *)str{
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}
@end
