//
//  PersonTimeManagerViewController.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/6.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseViewController.h"

@interface PersonTimeManagerViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/**
 *  滚动条
 */
@property (weak, nonatomic) IBOutlet UIView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *scrollViewBotomView;

@property (nonatomic,copy) NSString *shopId;//店铺id

@property (nonatomic,copy) NSString *peopleID;//人员id

@property (nonatomic,strong) NSMutableArray *dateArray;//数据源

-(void)createCustomScrollView;

- (IBAction)leftBtn:(id)sender;
- (IBAction)rightBtn:(id)sender;
@end
