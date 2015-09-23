//
//  OrderManagerTwoCell.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/5.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "OrderManagerTwoCell.h"

@implementation OrderManagerTwoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setProductModel:(ProductModel *)productModel{
    _productModel = productModel;
    [self.commodity_name setText:productModel.commodity_name];
    [self.amount setText:[NSString stringWithFormat:@"x%@",productModel.amount]];
    //@property (nonatomic,copy) NSString * amount;//商品数量
    //@property (nonatomic,copy) NSString * unit_price;//交易单价
    //@property (nonatomic,copy) NSString * commodity_name;//商品名称
    
}
@end
