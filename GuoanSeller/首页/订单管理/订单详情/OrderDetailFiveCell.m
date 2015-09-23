//
//  OrderDetailFiveCell.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/6.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "OrderDetailFiveCell.h"
#import "Const.h"
@implementation OrderDetailFiveCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setOModel:(OrderModel *)oModel{
    _oModel = oModel; 
    [self.total_priceLabel setText:[NSString stringWithFormat:@"￥%.2f", [OBJCNUM(oModel.total_price) floatValue]]];// 商品总金额
    [self.freight setText:[NSString stringWithFormat:@"￥%.2f",[OBJCNUM(oModel.freight) floatValue]]]; // 运费
    [self.coupon_id setText:[NSString stringWithFormat:@"-￥%.2f",[OBJCNUM(oModel.coupon_price) floatValue]]];//代金券价格
    [self.amount setText:[NSString stringWithFormat:@"￥%.2f",[OBJCNUM(oModel.amount) floatValue]]];//   应付金额

     
}
@end
