//
//  ShopListViewController.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/4.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseViewController.h"

@interface ShopListViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UICollectionView *collctionView;
@property (nonatomic,copy) NSString * member_id;//商家id
@end
