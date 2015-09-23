//
//  CommodityListModel.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/19.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseModel.h"

@interface CommodityListModel : BaseModel

@property (nonatomic,copy) NSString * commodity_id;//商品ID
@property (nonatomic,copy) NSString * pro_id;//产品库ID
@property (nonatomic,copy) NSString * auto_code;//商品分类id
@property (nonatomic,copy) NSString * member_id;//商家id
@property (nonatomic,copy) NSString * shoppe_id;//
@property (nonatomic,copy) NSString * is_self;//自营，非自营 0:非自营 1:自营

#pragma mark - 商品参数 yd
@property (nonatomic,copy) NSString * price;//价格
@property (nonatomic,copy) NSString * content_img;//商品图片
@property (nonatomic,copy) NSString * content_name;//商品名称
@property (nonatomic,copy) NSString * content_shelf;//商品状态
@property (nonatomic,copy) NSString * product_id;
@property (nonatomic,copy) NSString * content_preprice;//售价s
@property (nonatomic,copy) NSString * content_sale;//销量
@property (nonatomic,copy) NSString * create_time;//添加时间
@end
