//
//  CommodityManagement_sec_TableViewCell.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/7.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommodityListModel.h"
@interface ServiceManagement_sec_TableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *bjView;
@property (weak, nonatomic) IBOutlet UIButton *offTheShelfBtn;
@property (weak, nonatomic) IBOutlet UIButton *offTheShelf2Btn;

- (IBAction)offTheShelfBtn:(id)sender;
- (IBAction)offTheShelf2Btn:(id)sender;

@property (nonatomic,strong)  CommodityListModel * clModel;
#pragma mark - 参数
@property (weak, nonatomic) IBOutlet UIImageView *content_img;
@property (weak, nonatomic) IBOutlet UILabel *content_name;
@property (weak, nonatomic) IBOutlet UILabel *serviceAttitude;
@property (weak, nonatomic) IBOutlet UIButton *content_shelf;
@property (weak, nonatomic) IBOutlet UILabel *product_id;
@property (weak, nonatomic) IBOutlet UILabel *content_preprice;
@property (weak, nonatomic) IBOutlet UILabel *content_sale;
@property (weak, nonatomic) IBOutlet UILabel *create_time;
@property (strong, nonatomic) IBOutlet UILabel *favorablePrice_name;

@end
