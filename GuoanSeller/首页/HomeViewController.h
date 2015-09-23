//
//  HomeViewController.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/5.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseViewController.h"
#import "ShopListModel.h"



typedef void(^homeBlock)(BOOL isModify);
@interface HomeViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

#pragma mark - 店铺信息
@property (strong, nonatomic) IBOutlet UIImageView *picImage; //商家图片

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;//商家名字

@property (strong, nonatomic) IBOutlet UISwitch *statusSwitchbutton;//营业中
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (strong, nonatomic) IBOutlet UIButton *myAccountBtn;//我的收入

@property (strong, nonatomic) IBOutlet UILabel *priceLabel;//价格标签

@property (strong, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;//列表

- (IBAction)myAccountClick:(id)sender;
- (IBAction)statusSwitchBtn:(id)sender;

#pragma mark - 接收得店铺信息
@property (nonatomic,strong) ShopListModel * shoplistModel;
@property (nonatomic,copy) NSString * shopID;

@property (nonatomic,copy) NSString * manager_id;//店铺id
@property (nonatomic,copy) homeBlock   block;

@end
