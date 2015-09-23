//
//  OrderManagerLTableViewCell.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/7.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
#import "ServiceModel.h" 
@interface OrderManagerLTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *service_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *create_timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *total_priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *service_timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *appointment_start_timeLabel;

//@property (nonatomic,copy) NSString * appointment_start_time;//服务开始时间
//@property (nonatomic,copy) NSString * appointment_end_time;//服务结束时间
//@property (nonatomic,copy) NSString * service_time;//服务时长

@property (nonatomic,strong)  OrderModel * orderModel;
@property (nonatomic,strong)  ServiceModel * serviceModel;
@end
