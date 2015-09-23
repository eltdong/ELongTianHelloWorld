//
//  OrderManagerThreeCell.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/5.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
#import "ProductModel.h"
@interface OrderManagerThreeCell : UITableViewCell
#pragma mark - 参数
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;
@property (weak, nonatomic) IBOutlet UILabel *create_time;
@property (weak, nonatomic) IBOutlet UILabel *total_price;
@property (weak, nonatomic) IBOutlet UILabel *amount;

#pragma mark - 接受数据
@property (nonatomic,strong)  OrderModel * orderModel;
@property (nonatomic,strong)  ProductModel * productModel;
@end
