//
//  ShopManagementViewController.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/6.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "ShopManagementViewController.h"
#import "ShopMamagemetnTableViewCell.h"
#import "IntegralRuleViewController.h"
#import "ShopSignsViewController.h"
#import "BusinessHoursViewController.h"
#import "ELTModifyCustomView.h"
#import <AVFoundation/AVFoundation.h>
@interface ShopManagementViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,VPImageCropperDelegate,ELTModifyCustomViewDelegate>{
    UITapGestureRecognizer *_tap;//上传头像
    NSString *_headImage;
    NSString *_shopName;
    UIImage * _modify_image;
    ELTModifyCustomView *_modifyNameView;
    NSInteger _imageNum;
}
@end

@implementation ShopManagementViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [self downRequest];
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:HIDDEN_TABBAR object:@"1"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
    [ELTRefreshSingleton refreshIsOK].state = NO;
    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadImage)];
    
    self.scale = 74.0/74.0;
    
    _modifyNameView = [ELTModifyCustomView instanceView];
    _modifyNameView.hidden = YES;
    _modifyNameView.delegate = self;
    [self.view addSubview:_modifyNameView];
}

-(void)modifyNameClick:(UIButton *)button{
    
    if (button.tag == 1001) {
        _modifyNameView.hidden = YES;
    }else{
        [self modifyName];
    }
    
}

#pragma mark - 点击出现actionsheet
-(void)loadImage{
    [self showActionsheetWithPhoto];
}

#pragma mark - actionsheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
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
            
            break;
        case 1:  //打开本地相册
            [self openLocalPhoto];
            break;
    }
}

#pragma mark - 照相机照相
- (void)openCamera{
    
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

#pragma mark - 相册
- (void)openLocalPhoto{
    
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
        //portraitImg = [self imageByScalingToMaxSize:portraitImg];
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
//    __block _modify_image;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
        _modify_image = [UIImage fixOrientation:self.selfimage];
        
        [self uploadImage:_modify_image];
    }];
}


-(void)uploadImage:(UIImage *)image{
    
    self.indicator.frame = CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT);
    [self.indicator setIndicatorType:ActivityIndicatorLogin];
    [self.indicator startAnimatingActivit];
    
    [ELHttpRequestOperation getTokenAndTime];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",HTTP,@"&method=save&app_com=com_appcorpcenter&task=uploadimg"];
    
    ELHttpRequestOperation *sharedClient = nil;
    sharedClient = [ELHttpRequestOperation manager];
    [sharedClient setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [sharedClient setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [[sharedClient responseSerializer] setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [sharedClient POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.5) name:@"content_img_1" fileName:@"content_img_1.jpg"  mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.indicator LoadSuccess];
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        JSONDecoder * json = [[JSONDecoder alloc]init];
        NSDictionary * dic1 = [json objectWithData:responseObject];
        if ([[dic1 objectForKey:@"status"] integerValue] == 1) {
            NSArray *array = [dic1 objectForKey:@"datalist"];
            _headImage = [array firstObject];
            [self modifyHeadImage:_headImage];
        }else{
            
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

-(void)modifyHeadImage:(NSString *)headimage{
    
    [self.indicator startAnimatingActivit];
    [ELRequestSingle modifyShopHeadImageRequestWithBlock:^(BOOL sucess, id objc) {
        [self.indicator LoadSuccess];
        ShopMamagemetnTableViewCell *cell = (ShopMamagemetnTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        cell.headImage.image = _modify_image;
        [self showAlertViewWith:@"头像修改成功"];
        [ELTRefreshSingleton refreshIsOK].state = YES;
        /**
         *  yd
         */
        
        if (self.block) {
            self.block(YES);
        }
    } andShoppe_id:_shopId andName:@"" andPhoto:headimage];
    
}

-(void)modifyName{
    
    _modifyNameView.hidden = YES;
    [self.indicator startAnimatingActivit];
    [ELRequestSingle modifyShopHeadImageRequestWithBlock:^(BOOL sucess, id objc) {
        [self.indicator LoadSuccess];
        ShopMamagemetnTableViewCell *cell = (ShopMamagemetnTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
        cell.secondLabel.text = _modifyNameView.nameField.text;
        [self showAlertViewWith:@"名称修改成功"];
        [ELTRefreshSingleton refreshIsOK].state = YES;
    } andShoppe_id:_shopId andName:_modifyNameView.nameField.text andPhoto:@""];
    
}

//图片界面点击取消
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)createUI{
    self.navbar.titleLabel.text = @"店铺管理";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(void)back:(id)sender{
    
    if (_isEdit) {
        [ELTRefreshSingleton refreshIsOK].state = YES;
        [self.navigationController popToRootViewControllerAnimated:YES]; 
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    static NSString *CellIndetifier = @"ShopMamagemetnTableViewCell";
    
    ShopMamagemetnTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIndetifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ShopMamagemetnTableViewCell" owner:nil options:nil];
        switch (indexPath.row) {
            case 0:
            {
                cell = nibs[0];
                if (![_headImage isEqualToString:@""] && _headImage!=NULL) {
                    [cell.headImage setImageWithURL:[NSURL URLWithString:_headImage]];
                }
                [cell.headImage addGestureRecognizer:_tap];
                
            }
                break;
            case 1:
            {
                cell = nibs[4];
                cell.firstLabel.text = @"店铺招牌";
                cell.secondLabel.text = _imageNum == 0 ? @"您还未设置招牌图片":[NSString stringWithFormat:@"您已设置%ld张招牌图片",_imageNum];
            }
                break;
            case 2:
            {
                cell = nibs[2];
                cell.secondLabel.text = _shopName;
            }
                break;
            case 3:
            {
                cell = nibs[1];
            }
                break;
            case 4:
            {
                 cell = nibs[3];
               
            }
                break;
            case 5:
            {
                 cell = nibs[4];
            }
                break;
            case 6:
            {
                cell = nibs[3];
            cell.secondLabel.text = @"配送范围";
                
            }
                break;
          
            default:{
                cell.backgroundColor = UIColorFromRGB(0xf5f5f5);
            }
                break;
        }

    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
        {
            ShopSignsViewController *vc=[[ShopSignsViewController alloc]init];
            vc.shopId = _shopId;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
            _modifyNameView.hidden = NO;
            break;
        case 3:
        {
            IntegralRuleViewController *ir = [[IntegralRuleViewController alloc]init];
            [self.navigationController pushViewController:ir animated:YES];
        }
            break;
        case 4:
        {
            BusinessHoursViewController *vc = [[BusinessHoursViewController alloc]init];
            vc.shoppe_id = _shopId;
            vc.isEdit = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
            
            break;
        case 6:
            
            break;
            
            
        default:
            break;
    }
}

-(void)downRequest{
    
    [self.indicator startAnimatingActivit];
    [ELRequestSingle getShopDetailRequestWithBlock:^(BOOL sucess, id objc) {
        NSDictionary *dic = objc;
        _headImage = [dic objectForKey:@"content_img"];
        _shopName = [dic objectForKey:@"name"];
        _modifyNameView.nameField.text = _shopName;
        _imageNum = [[dic objectForKey:@"image_num"]integerValue];
        [self.tableView reloadData];
        [self.indicator LoadSuccess];
    } andShoppe_id:_shopId];
    
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
@end
