//
//  OrderManagerSTableViewCell.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/7.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
#import "ServiceModel.h"
@interface OrderManagerSTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *service_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *person_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *create_timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *total_priceLabel;
@property (nonatomic,strong)  OrderModel * orderModel;
@property (nonatomic,strong)  ServiceModel * serviceModel;

@end
