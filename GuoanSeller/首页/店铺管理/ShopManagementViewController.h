//
//  ShopManagementViewController.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/6.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseViewController.h"
#import "VPImageCropperViewController.h"
#import "UIImage+Expland.h"

typedef void(^shopmanageBlock)(BOOL success);// 判断图片上传成功与否
@interface ShopManagementViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) float scale;
@property (retain, nonatomic) UIImage * selfimage;


//判断是不是从添加店铺跳转过来的。
@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic,copy) NSString *shopId;
@property (nonatomic,copy) shopmanageBlock block;// 判断图片上传成功与否

@end
