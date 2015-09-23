//
//  StaffSelectViewController.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/10.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^StaffselBlock)(NSMutableArray * arr);

@interface StaffSelectViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UIButton *allBtn;

@property (nonatomic, copy) NSString * shoppe_id;

@property (nonatomic, strong) NSArray * idArr;

@property (nonatomic,copy) StaffselBlock block;

@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, strong) NSMutableArray * seleceBtnArr;

@end
