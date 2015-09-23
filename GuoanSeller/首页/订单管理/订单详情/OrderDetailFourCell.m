//
//  OrderDetailFourCell.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/6.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "OrderDetailFourCell.h"

@implementation OrderDetailFourCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setPModel:(ProductModel *)pModel{
    _pModel = pModel;
    [self.commodity_name setText:pModel.commodity_name];
    [self.amount setText:[NSString stringWithFormat:@"x%@",pModel.amount]];
    [self.unit_price setText:[NSString stringWithFormat:@"￥%@",pModel.unit_price]];
    
    
}
@end
