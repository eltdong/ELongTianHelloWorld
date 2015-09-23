//
//  ShopSignsViewController.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/7.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "ShopSignsViewController.h"
#import "VPImageCropperViewController.h"
#import "UIImage+Expland.h"
#import "UIImage+ZLPhotoLib.h"
#import "ZLPhoto.h"
#import "LxGridView.h"
#import "Example2CollectionViewCell.h"
#import "LxGridViewCell.h"
#import "ELTShopImageCollectionReusableView.h"

static NSString * const LxGridViewCellReuseIdentifier = @stringify(LxGridViewCellReuseIdentifier);

@interface ShopSignsViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIAlertViewDelegate,VPImageCropperDelegate,ZLPhotoPickerBrowserViewControllerDelegate,ZLPhotoPickerBrowserViewControllerDataSource,LxGridViewDataSource, LxGridViewDelegateFlowLayout, LxGridViewCellDelegate,UIAlertViewDelegate>{
//    UIActionSheet *_sheet;
    LxGridViewFlowLayout * _gridViewFlowLayout;
    ELTShopImageCollectionReusableView *_headerView;
    VPImageCropperViewController *_imgCropperVC;
}

@property (nonatomic, strong) LxGridView * gridView;
@property (weak,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) ZLCameraViewController *cameraVc;

@end

@implementation ShopSignsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.mainTable registerNib:[UINib nibWithNibName:@"ShopImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopImageTableViewCell"];
    self.navbar.titleLabel.text = @"店铺招牌";
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(SCREENWIDTH - 52, 30, 40, 30);
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navbar addSubview:rightBtn];

    self.scale = 1.0/3.0;
    
//    _sheet = [[UIActionSheet alloc] initWithTitle:nil
//                                                        delegate:self
//                                               cancelButtonTitle:@"取消"
//                                          destructiveButtonTitle:nil
//                                otherButtonTitles:@"拍照", @"从相机选择", nil];
    

    
    [self setupCollectionView];
    [self downRequest];
    
//    _imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:asset.originImage cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width*self.scale) limitScaleRatio:3.0];
//    _imgCropperVC.delegate = self;
    
}

-(void)downRequest{
    
    [self.indicator startAnimatingActivit];
    [ELRequestSingle shopImageListRequestWithBlock:^(BOOL sucess, id objc) {
        
        [self.indicator LoadSuccess];
        _imageArray = [NSMutableArray arrayWithArray:objc];
        _assets = [NSMutableArray arrayWithArray:_imageArray];
        
        if (!_assets.count) {
            [_assets addObject:[UIImage imageNamed:@"uppic.png"]];
        }
        [_gridView reloadData];
        
    } andLink_id:_shopId];
    
}

-(void)rightClick{
    
    [ELRequestSingle modifyShopImageRequestWithBlock:^(BOOL sucess, id objc) {
        [self.navigationController popViewControllerAnimated:YES];
    } andShoppe_id:_shopId andImage:_imageArray];
}

#pragma mark setup UI
- (void)setupCollectionView{
    
    _gridViewFlowLayout = [[LxGridViewFlowLayout alloc]init];
    _gridViewFlowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 15, 15);
    _gridViewFlowLayout.minimumLineSpacing = 9;
    _gridViewFlowLayout.isEdited = YES;
    _gridView = [[LxGridView alloc]initWithFrame:CGRectMake(0, 114, SCREENWIDTH, SCREENHEIGHT - 114) collectionViewLayout:_gridViewFlowLayout];
    _gridView.delegate = self;
    _gridView.dataSource = self;
    _gridView.scrollEnabled = YES;
    _gridView.showsVerticalScrollIndicator = NO;
    _gridView.editing = YES;
    _gridView.backgroundColor = [UIColor clearColor];
    [_gridView registerNib:[UINib nibWithNibName:@"ELTShopImageCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
       withReuseIdentifier:@"ELTShopImageCollectionReusableView"];
    [self.view addSubview:_gridView];
    
    
    [_gridView registerNib:[UINib nibWithNibName:@"Example2CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Example2CollectionViewCell"];
    
    [_gridView registerClass:[LxGridViewCell class] forCellWithReuseIdentifier:LxGridViewCellReuseIdentifier];
    
    _gridView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
}

#pragma mark --UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(SCREENWIDTH - 30, (SCREENWIDTH - 30)/3);
    
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.assets.count < 4){
        return self.assets.count;
    }else{
        return 4;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (!_imageArray.count && _assets.count == 1) {
        Example2CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Example2CollectionViewCell" forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:@"uppic.png"];
        return cell;
    }else{
        LxGridViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:LxGridViewCellReuseIdentifier forIndexPath:indexPath];
        // 判断类型来获取Image
        
        ZLPhotoAssets *asset = self.assets[indexPath.item];
        if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
            cell.iconImageView.image = asset.thumbImage;
        }else if ([asset isKindOfClass:[NSString class]]){
            [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:(NSString *)asset] placeholderImage:[UIImage imageNamed:@"pc_circle_placeholder"]];
        }else if([asset isKindOfClass:[UIImage class]]){
            cell.iconImageView.image = (UIImage *)asset;
            cell.iconImageView.backgroundColor = [UIColor yellowColor];
        }else if ([asset isKindOfClass:[ZLCamera class]]){
            cell.iconImageView.image = [asset thumbImage];
        }
        cell.delegate = self;
        //        cell.editing = _gridView.editing;//yd
        cell.tag = indexPath.item;
        cell.isEdited = YES;
        cell.topShadowView.hidden = YES;
        cell.isDeleteBtn = YES;
        return cell;
    }

}
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath willMoveToIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSDictionary * dataDict = self.assets[sourceIndexPath.item];
    [self.assets removeObjectAtIndex:sourceIndexPath.item];
    [self.assets insertObject:dataDict atIndex:destinationIndexPath.item];
    [_imageArray exchangeObjectAtIndex:destinationIndexPath.item withObjectAtIndex:sourceIndexPath.item];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionFooter){
        _headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ELTShopImageCollectionReusableView" forIndexPath:indexPath];
    }
    [_headerView.addImage addTarget:self action:@selector(addImageClick) forControlEvents:UIControlEventTouchUpInside];
    return _headerView;
}

-(void)addImageClick{
    [self showActionsheetWithPhoto];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    if (_imageArray.count >= 4) {
        return CGSizeMake(0,0);
    }
    return CGSizeMake(SCREENWIDTH, 63);
    
}

#pragma mark - 删除
- (void)deleteButtonClickedInGridViewCell:(LxGridViewCell *)gridViewCell
{
    [self.assets removeObjectAtIndex:gridViewCell.tag];
    [_imageArray removeObjectAtIndex:gridViewCell.tag];
    [self.gridView reloadData];
}
#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!_imageArray.count) {
        return;
    }
    
        // 图片游览器
        ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
        
        // 数据源/delegate
        // 动画方式
        /*
         *
         UIViewAnimationAnimationStatusZoom = 0,  放大缩小
         UIViewAnimationAnimationStatusFade ,  淡入淡出
         UIViewAnimationAnimationStatusRotate  旋转
         
         */
        pickerBrowser.status = UIViewAnimationAnimationStatusFade;
        pickerBrowser.status = UIViewAnimationAnimationStatusZoom;
        pickerBrowser.delegate = self;
        pickerBrowser.dataSource = self;
        // 是否可以删除照片
        pickerBrowser.editing = YES;
        // 传入组
        pickerBrowser.currentIndexPath = indexPath;
        // 展示控制器
        [pickerBrowser showPickerVc:self];
}

- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return [self.assets count];
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    id imageObj = [self.assets objectAtIndex:indexPath.item];
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    LxGridViewCell *cell = (LxGridViewCell *)[self.gridView cellForItemAtIndexPath:indexPath];
    // 缩略图
    if ([imageObj isKindOfClass:[ZLPhotoAssets class]]) {
        photo.asset = imageObj;
    }
    photo.toView = cell.iconImageView;
    photo.thumbImage = cell.iconImageView.image;
    return photo;
}

#pragma mark - <ZLPhotoPickerBrowserViewControllerDelegate>

- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row> [self.assets count]) return;
    [self.assets removeObjectAtIndex:indexPath.row];
    [_imageArray removeObjectAtIndex:indexPath.row];
    [_gridView reloadData];
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
        if (_assets.count == 1) {
            if (!_imageArray.count) {
                [self.assets replaceObjectAtIndex:0 withObject:modify_image];
            }else{
                [self.assets addObject:modify_image];
            }
        }else{
            [self.assets addObject:modify_image];
        }
        [self uploadImage:modify_image];
        
    }];
}
//图片界面点击取消
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}



-(void)back:(id)sender{
    
    if (_imageArray.count) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"是否要放弃对店铺招牌的修改？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)uploadImage:(UIImage *)image{

    self.indicator = [[ActivityIndicator alloc]initWithFrame:CGRectMake(0, 64, _gridView.frame.size.width, _gridView.frame.size.height) LabelText:@"正在加载..." withdelegate:self withType:ActivityIndicatorLogin andAction:nil];
    [_gridView addSubview:self.indicator];
    [self.indicator startAnimatingActivit];

    [ELHttpRequestOperation getTokenAndTime];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",HTTP,@"&method=save&app_com=com_appcorpcenter&task=uploadimg"];
    ELHttpRequestOperation *sharedClient = nil;
    sharedClient = [ELHttpRequestOperation manager];
    [sharedClient setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [sharedClient setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [[sharedClient responseSerializer] setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [sharedClient POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1.0) name:@"content_img_1" fileName:@"content_img_1.jpg"  mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.indicator LoadSuccess];
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        JSONDecoder * json = [[JSONDecoder alloc]init];
        NSDictionary * dic1 = [json objectWithData:responseObject];
        if ([[dic1 objectForKey:@"status"] integerValue] == 1) {
            NSArray *array = [dic1 objectForKey:@"datalist"];
            [_imageArray addObject:[array firstObject]];
            
        }
        [_gridView reloadData];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];

}

@end
