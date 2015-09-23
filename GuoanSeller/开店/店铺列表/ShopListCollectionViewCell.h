//
//  ShopListCollectionViewCell.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/4.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopListModel.h"
@interface ShopListCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel; //店铺名称

@property (strong, nonatomic) IBOutlet UIImageView *topImage;//状态判断 yd

@property (strong, nonatomic) IBOutlet UIImageView *bottomImage;//店铺头像
#pragma mark - 接受数据 yd
@property (nonatomic,strong) ShopListModel * shoplistModel;
@end
