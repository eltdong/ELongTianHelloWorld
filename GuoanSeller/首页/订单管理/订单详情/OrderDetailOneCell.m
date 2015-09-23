//
//  OrderDetailOneCell.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/6.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "OrderDetailOneCell.h"

@implementation OrderDetailOneCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setOModel:(OrderModel *)oModel{
    _oModel = oModel;
//    @property (weak, nonatomic) IBOutlet UILabel *content_sn;
//    @property (weak, nonatomic) IBOutlet UILabel *order_status;
//    @property (weak, nonatomic) IBOutlet UILabel *create_time;
//    @property (weak, nonatomic) IBOutlet UILabel *total_price;
//    @property (weak, nonatomic) IBOutlet UILabel *pay_time;
//    @property (weak, nonatomic) IBOutlet UILabel *order_remarks;
    [self.content_sn setText:oModel.content_sn];
    [self.order_status setText:oModel.order_status];
    [self.create_time setText:oModel.create_time];//下单时间
    [self.total_price setText:[NSString stringWithFormat:@"￥%.2f",[OBJCNUM( oModel.total_price) floatValue]]];
    [self.pay_time setText:oModel.create_time];//付款时间 == 下单时间
    [self.order_remarks setText:[NSString stringWithFormat:@"%@",(oModel.order_remarks == NULL)? @"" : oModel.order_remarks ] ];

}
@end
