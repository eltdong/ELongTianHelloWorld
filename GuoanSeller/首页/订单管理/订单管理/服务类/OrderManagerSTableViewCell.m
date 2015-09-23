//
//  OrderManagerSTableViewCell.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/7.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "OrderManagerSTableViewCell.h"

@implementation OrderManagerSTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setOrderModel:(OrderModel *)orderModel{
    [self.person_nameLabel setText:[NSString stringWithFormat:@"%@",orderModel.person_name]];
    [self.create_timeLabel setText:orderModel.create_time];
    [self.total_priceLabel setText:[NSString stringWithFormat:@"￥%.2f",[OBJCNUM(orderModel.total_price) floatValue]]];
    
}
-(void)setServiceModel:(ServiceModel *)serviceModel{
    [self.service_nameLabel setText:serviceModel.service_name];
    
}
@end
