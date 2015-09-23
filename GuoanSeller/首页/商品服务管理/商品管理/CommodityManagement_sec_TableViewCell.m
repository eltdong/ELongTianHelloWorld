//
//  CommodityManagement_sec_TableViewCell.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/7.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "CommodityManagement_sec_TableViewCell.h"
@implementation CommodityManagement_sec_TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)offTheShelfBtn:(id)sender {
}

- (IBAction)offTheShelf2Btn:(id)sender {
}
-(void)setClModel:(CommodityListModel *)clModel{
    _clModel  = clModel;
    [self.content_img setImageWithURL:[NSURL URLWithString:clModel.content_img] placeholderImage:[UIImage imageNamed:CUSTOMPLACEHOLDERIMAGE]];//占位图
//    [self.content_img setImageWithURL:[NSURL URLWithString:clModel.content_img]];
    [self.content_name setText:clModel.content_name];
    [self.content_shelf setTitle:clModel.content_shelf forState:UIControlStateNormal];
    
    [self.product_id setText:[NSString stringWithFormat:@"￥%@",OBJCNUM(clModel.content_preprice)]];
    
    /**
     *  对优惠金额的判断
     */
    NSString * discountAmount;
    if (([OBJCNUM(clModel.price) integerValue] - [OBJCNUM(clModel.content_preprice) integerValue]) < 0) {
        discountAmount = @"0";
    }
    else{
        discountAmount = [NSString stringWithFormat:@"%ld",[OBJCNUM(clModel.price) integerValue] - [OBJCNUM(clModel.content_preprice) integerValue]];
    }
    [self.content_preprice setText:[NSString stringWithFormat:@"￥%@",discountAmount]];
    
    [self.content_sale setText:[NSString stringWithFormat:@"总销量 %@",clModel.content_sale]];
    [self.create_time setText:clModel.create_time]; 
 }
@end
