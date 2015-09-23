//
//  OrderManagerOneCell.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/5.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "OrderManagerOneCell.h"
#import "Const.h"
#import <CoreText/CoreText.h>
@implementation OrderManagerOneCell

- (void)awakeFromNib {
    
    /**
     计算字间距
     */
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.consigneeName.text];
    long number = 2.0f;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)(num) range:NSMakeRange(0,[attributedString length])];
    self.consigneeName.attributedText = attributedString;   
    CFRelease(num );
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
// 赋值
-(void)setOrderModel:(OrderModel *)orderModel{

    [self.content_sn setText:[NSString stringWithFormat:@"订单编号：%@",orderModel.content_sn]];
    [self.order_status setText:[NSString stringWithFormat:@"%@",orderModel.order_status]];
    [self.consignee setText:[NSString stringWithFormat:@"%@",orderModel.consignee]];
    [self.consignee_phone setText:[NSString stringWithFormat:@"%@",orderModel.consignee_phone]];
    [self.address setText:[NSString stringWithFormat:@"收货地址：%@",orderModel.address]];
      
}
@end
