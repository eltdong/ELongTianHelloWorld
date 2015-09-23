//
//  OrderManagerThreeCell.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/5.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "OrderManagerThreeCell.h"
#import "ProductModel.h"
@implementation OrderManagerThreeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setOrderModel:(OrderModel *)orderModel{
    _orderModel = orderModel;
    
    [self.create_time setText:orderModel.create_time];
    [self.total_price setText:[NSString stringWithFormat:@"￥%.2f",[OBJCNUM(orderModel.total_price) floatValue]]];
    
    
    
    NSArray * arr = orderModel.pro;
    if (arr.count>3) {
        self.lineImageView.hidden = NO;
    }
    else{
        self.lineImageView.hidden = YES;
    }
    NSInteger num = 0;
    for (NSInteger i = 0; i < arr.count; i  ++) {
        ProductModel * pModel = arr[i];
        num += [pModel.amount integerValue];
    }
    
    [self.amount  setText:[NSString stringWithFormat:@"共%ld件商品",num]];
    
}
@end
