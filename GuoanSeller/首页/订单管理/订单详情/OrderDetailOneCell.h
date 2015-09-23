//
//  OrderDetailOneCell.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/6.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
@interface OrderDetailOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *content_sn;
@property (weak, nonatomic) IBOutlet UILabel *order_status;
@property (weak, nonatomic) IBOutlet UILabel *create_time;
@property (weak, nonatomic) IBOutlet UILabel *total_price;
@property (weak, nonatomic) IBOutlet UILabel *pay_time;
@property (weak, nonatomic) IBOutlet UILabel *order_remarks;


@property (nonatomic,strong)  OrderModel * oModel;

@end
