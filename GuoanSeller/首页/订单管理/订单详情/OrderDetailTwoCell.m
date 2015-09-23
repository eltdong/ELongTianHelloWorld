//
//  OrderDetailTwoCell.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/6.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "OrderDetailTwoCell.h"
#import <CoreText/CoreText.h>
@implementation OrderDetailTwoCell

- (void)awakeFromNib {
    // Initialization code
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.consigneeName.text];
    long number = 1.9f;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)(num) range:NSMakeRange(0,[attributedString length])];
    self.consigneeName.attributedText = attributedString;
    CFRelease(num );

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setOModel:(OrderModel *)oModel{
    _oModel = oModel; 
    [self.customer_id setText:oModel.customer_name];// 待考
    [self.consignee setText:oModel.consignee];
    [self.consignee_phone setText:oModel.consignee_phone];
    [self.address setText:oModel.address];
    [self.evaluation_comment setText:OBJCREMARK(oModel.evaluation_comment)];

}
@end
