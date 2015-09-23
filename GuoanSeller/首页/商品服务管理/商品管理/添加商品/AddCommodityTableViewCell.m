//
//  AddCommodityTableViewCell.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/8.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "AddCommodityTableViewCell.h"

@interface AddCommodityTableViewCell()<UITextViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong) NSMutableDictionary *paraDic;
@end

@implementation AddCommodityTableViewCell

-(NSMutableDictionary *)paraDic{
    if (!_paraDic) {
        _paraDic = [NSMutableDictionary dictionary];
    }
    return _paraDic;
}
- (void)awakeFromNib {
    // Initialization code
    self.textView.delegate = self;
    self.textView.layer.masksToBounds =YES;
    self.textView.layer.borderColor = UIColorFromRGB(0xf1f1f1).CGColor;
    self.textView.layer.borderWidth = 1.0f;
    
    self.onShelfCommodityBtn.layer.masksToBounds =YES;
    self.onShelfCommodityBtn.layer.cornerRadius = 2.5f;
    if ([self.textView.text length] != 0) {
        self.describeLabel.hidden = YES;
    }
    
    self.inputField.delegate = self;
} 
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    self.describeLabel.hidden = YES;
    
}  
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)pullDownClick:(id)sender {
    [self.delegate pullDownBtnClick:sender];
    
}
 
-(void)textFieldDidEndEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 1:
        {
            NSLog(@"%@",textField.text);
            [self.paraDic setObject:textField.text forKey:@"duct[content_name]"];//    duct[content_name]	String	N	商品名
        }
            break;
        case 2:
        {
            [self.paraDic setObject:textField.text forKey:@"duct[content_price]"];//    duct[content_price]	double	N	商品价格
        }
            break;
            
        case 3:
        {
            [self.paraDic setObject:textField.text forKey:@"duct[content_name]"];//优惠价格
        }
            break;
            
        case 4:
        {
            [self.paraDic setObject:textField.text forKey:@"duct[content_brand]"];//    duct[content_brand]	int	N	商品品牌
        }
            break;
            
        case 6:
        {
            [self.paraDic setObject:textField.text forKey:@"duct[weight]"]; //    duct[weight]	int	N	重量
        }
            break;
            
        case 7:
        {
            [self.paraDic setObject:textField.text forKey:@"duct[content_expiration]"];  //    duct[content_expiration]	String	N	保质期
        }
            break;
            
        case 8:
        {
            [self.paraDic setObject:textField.text forKey:@"duct[specifications]"];//    duct[specifications]	String	N	商品规格
        }
            break;
        default:
            break;
    }
    if (self.delegate &&[self.delegate respondsToSelector:@selector(getCustomParadic:)]) {
        [self.delegate getCustomParadic:self.paraDic];
    }
    if (self.delegate &&[self.delegate respondsToSelector:@selector(textViewDidEndEditing)]) {
        [self.delegate textViewDidEndEditing];
    }
//    duct[content_name]	String	N	商品名
//    duct[auto_code]	String	N	分类编码
//    duct[content_price]	double	N	商品价格
//    duct[content_expiration]	String	N	保质期
//    duct[content_brand]	int	N	商品品牌
//    duct[weight]	int	N	重量
//    duct[specifications]	String	N	商品规格
//    请求字段说明—商品库表（pro）
//    pro[auto_code]	String	N	分类编码
//    pro[content_preprice]	double	N	售价
//    pro[content_self]	int	N	上下架类型	1：上架，2:下架，3补货中
//    请求字段说明—商品详情表（body）
//    body[content_mbody]	String	N	详情
//    请求字段说明—查询条件字段
//    pro_id	int	N	商品表ID
//    member_id	int	N	会员ID	
//    shoppe_id	int	N	店铺ID
    
     }

 

- (IBAction)onShelfCommodityBtn:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onShelfCommodityBtn)]) {
        [self.delegate onShelfCommodityBtn];
    }
}

 
@end
