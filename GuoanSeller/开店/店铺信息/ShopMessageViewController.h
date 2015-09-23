//
//  ShopMessageViewController.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/7.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseViewController.h"
#import "UIImage+Expland.h"
#import "FileUtil.h"
#import "VPImageCropperViewController.h"
#import "JSONKit.h"
#import "CommonFunc.h"
#import "ELTTimeShopMessageTableViewCell.h"


#define kPhotoName              @"headImage.jpg"
#define kImageCachePath         @"imagecache"
#define kImageBinary            @"imageBinary.plist"
#define kImageBlinarykey        @"HeadImage"

#define ORIGINAL_MAX_WIDTH 640.0f
@interface ShopMessageViewController : BaseViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,VPImageCropperDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *bgTable;

@property (strong, nonatomic) IBOutlet UIButton *bottomBtn;
@property (assign, nonatomic) float scale;
@property (retain, nonatomic) UIImage * selfimage;

- (IBAction)bottomClick:(id)sender;



@property (nonatomic, copy) NSString * type; //店铺类型  10 服务  20 商品
@property (nonatomic, copy) NSString * name; //姓名
@property (nonatomic, copy) NSString * ID; //身份证号
@property (nonatomic, copy) NSString * imgOne;
@property (nonatomic, copy) NSString * imgTwo;
@end
