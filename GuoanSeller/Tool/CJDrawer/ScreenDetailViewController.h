//
//  ScreenDetailViewController.h
//  TangRen
//
//  Created by 易龙天 on 15/6/30.
//  Copyright (c) 2015年 易龙天. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScreenDetailTableViewCell.h"
#import "Const.h"

@protocol ScreenDetailViewControllerDelegate <NSObject>

- (void)popView:(BJObject *)obj;

@end

@interface ScreenDetailViewController : UIViewController

@property (nonatomic, weak) id<ScreenDetailViewControllerDelegate>delagate;
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (nonatomic, strong) NSMutableArray * subArr;
@end
