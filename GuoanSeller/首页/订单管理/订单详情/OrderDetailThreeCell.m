//
//  OrderDetailThreeCell.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/6.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "OrderDetailThreeCell.h"
#import "ProductModel.h" 
@implementation OrderDetailThreeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setOModel:(OrderModel *)oModel{
    _oModel = oModel;
    NSArray * arr = oModel.pro;
     NSInteger num = 0;
    for (NSInteger i = 0; i < arr.count; i ++) {
        ProductModel * pModel = arr[i];
        num +=  [pModel.amount integerValue];
    }
    NSString * str = [NSString stringWithFormat:@"%ld",num];
    [self.amount setText:[NSString stringWithFormat:@"［共%@件商品］",OBJCREMARK(str)]];
    
}
@end
