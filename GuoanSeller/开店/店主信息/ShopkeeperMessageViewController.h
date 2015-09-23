//
//  ShopkeeperMessageViewController.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/4.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseViewController.h"
#import "VPImageCropperViewController.h"
#import "ZLPhoto.h"
#import <AVFoundation/AVFoundation.h>


@interface ShopkeeperMessageViewController : BaseViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,VPImageCropperDelegate>

@property (strong, nonatomic) IBOutlet UITableView *bgTable;
@property (assign, nonatomic) float scale;
@property (retain, nonatomic) UIImage * selfimage;
@property (nonatomic, copy) NSString * type;

@end
