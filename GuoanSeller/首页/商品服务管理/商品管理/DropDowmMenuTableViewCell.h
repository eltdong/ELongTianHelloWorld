//
//  DropDowmMenuTableViewCell.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/8.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassificationModel.h"
#import "ClassificationSecModel.h"
@interface DropDowmMenuTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selbfBtn;
@property (weak, nonatomic) IBOutlet UIButton *classficationBtn;
@property (weak, nonatomic) IBOutlet UIButton *arrowBtn;

#pragma mark - 大小分类
@property (weak, nonatomic) IBOutlet UILabel *mainClassLabel;
@property (weak, nonatomic) IBOutlet UIView *mainUnderline;
@property (weak, nonatomic) IBOutlet UIButton *selgoBtn;
@property (weak, nonatomic) IBOutlet UILabel *smallClassLabel;
@property (weak, nonatomic) IBOutlet UIView *smallUnderline;
@property (nonatomic,strong)  ClassificationModel * cModel;
@property (nonatomic,strong)  ClassificationSecModel * csModel;
@end
