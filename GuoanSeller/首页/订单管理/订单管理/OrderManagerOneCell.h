//
//  OrderManagerOneCell.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/5.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
@interface OrderManagerOneCell : UITableViewCell
#pragma mark - 参数
@property (weak, nonatomic) IBOutlet UILabel *content_sn;
@property (weak, nonatomic) IBOutlet UILabel *order_status;
@property (weak, nonatomic) IBOutlet UILabel *consignee;//收货人
@property (weak, nonatomic) IBOutlet UILabel *consigneeName;

@property (weak, nonatomic) IBOutlet UILabel *consignee_phone;
@property (weak, nonatomic) IBOutlet UILabel *address;

#pragma mark - 接受数据
@property (nonatomic,strong)  OrderModel * orderModel;
@end
