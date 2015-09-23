//
//  OrderDetailSTableViewCell.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/7.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "OrderDetailSTableViewCell.h"

@implementation OrderDetailSTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setOrderModel:(OrderModel *)orderModel{
    [self.discountLabel setText:[NSString stringWithFormat:@"-￥%.2f",[orderModel.coupon_price floatValue]]];//代金券价格
    [self.priceLabel setText:[NSString stringWithFormat:@"￥%.2f",[orderModel.total_price floatValue]]];//订单金额
    [self.payLabel setText:[NSString stringWithFormat:@"￥%.2f",[orderModel.price floatValue]]];//应付金额
    
    if ([orderModel.is_limit isEqualToString:@"2"]) {//有限资源  显示时间区间
        
        NSString * temp = orderModel.appointment_start_time;
         NSString *temp001 = [temp stringByReplacingCharactersInRange:NSMakeRange([orderModel.appointment_start_time length] - 3, 3) withString:@""];//去掉字符串的后几位
        [self.timeLabel setText:[NSString stringWithFormat:@"%@",temp001]];//服务时间
        
        [self.personTitleLabel setText:@"服务人员"];//服务人员
        [self.personLabel setText:[NSString stringWithFormat:@"%@",orderModel.person_name]];//人员名字
        
    }
    else {//无限资源  只显示开始时间
    
    [self.timeLabel setText:[NSString stringWithFormat:@"%@小时",orderModel.service_time]];//服务时间
    [self.personTitleLabel setText:@"预约时间"];//预约时间
//        [self.personLabel setText:[self recombineWithStr:orderModel.appointment_start_time and:orderModel.service_time]];
        
        
        NSString * temp = orderModel.appointment_start_time;
        NSString *temp001 = [temp stringByReplacingCharactersInRange:NSMakeRange([orderModel.appointment_start_time length] - 3, 3) withString:@""];//去掉字符串的后几位
        [self.personLabel setText:temp001];
    }
}
-(void)setServiceModel:(ServiceModel *)serviceModel{
    [self.nameLabel setText:serviceModel.service_name];//服务信息 
}
-(NSString *)recombineWithStr:(NSString *)str1 and:(NSString *)str2{
    NSString * temp000 = str1;
    NSString *temp001 = [temp000 stringByReplacingCharactersInRange:NSMakeRange([temp000 length] - 3, 3) withString:@""];
    NSArray * strArr001 = [temp001 componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" :"]];
    NSString * str02 = [NSString stringWithFormat:@"%ld",[[strArr001 objectAtIndex:1] integerValue] + [str2 integerValue]];
    NSString * finalStr1 = [NSString stringWithFormat:@"%@:%@",str02,[strArr001 objectAtIndex:2]];
    return [NSString stringWithFormat:@"%@-%@",temp001,finalStr1];
}
@end
