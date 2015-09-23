//
//  OrderManagerLTableViewCell.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/7.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "OrderManagerLTableViewCell.h"

@implementation OrderManagerLTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setOrderModel:(OrderModel *)orderModel{
    
    [self.create_timeLabel setText:orderModel.create_time];
    [self.total_priceLabel setText:[NSString stringWithFormat:@"￥%.2f",[OBJCNUM(orderModel.total_price) floatValue]]];
    [self.service_timeLabel setText:[NSString stringWithFormat:@"%@小时",orderModel.service_time]];
    [self.appointment_start_timeLabel setText:orderModel.appointment_start_time];
}
-(void)setServiceModel:(ServiceModel *)serviceModel{
    [self.service_nameLabel setText:serviceModel.service_name];
    
}
@end
