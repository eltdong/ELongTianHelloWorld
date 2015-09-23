

//
//  CommodityDetailModel.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/27.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseModel.h"


@interface CommodityDetailModel : BaseModel


//@property (nonatomic, copy) NSString *id;//商品表ID
@property (nonatomic, copy) NSString *pro_id;//商品表ID*

@property (nonatomic, copy) NSString  *content_name;//商品名字

@property (nonatomic, copy) NSString *content_price;//市场价
@property (nonatomic, copy) NSString *content_preprice;// 优惠价
@property (nonatomic, copy) NSString *content_brand;//商品品牌
@property (nonatomic, copy) NSString *auto_code;//分类编码
//@property (nonatomic, copy) NSString *class;//分类
@property (nonatomic,copy) NSString * classifationName;//分类
@property (nonatomic, copy) NSString *weight;//重量
@property (nonatomic, copy) NSString *content_expiration;//保质期

@property (nonatomic, copy) NSString *specifications;//商品规格
@property (nonatomic, copy) NSString *content_shelf;//商品状态
@property (nonatomic, copy) NSString *content_shelf_status;//商品状态值*
@property (nonatomic, copy) NSString * promotion_price; //促销价格

@property (nonatomic,strong)  NSMutableArray * show;//   商品图集*

@property (nonatomic,copy) NSString * content_mbody;//商品简介*

@property (nonatomic, copy) NSString *is_self;//0:非自营 1:自营

@property (nonatomic, copy) NSString *shoppe_id;//

@property (nonatomic, copy) NSString *content_img;//


@property (nonatomic, copy) NSString *product_id;//


@property (nonatomic, copy) NSString *content_num;//




@property (nonatomic, copy) NSString *member_id;//

//id	int(11)	N	商品表ID
//返回字段说明
//参数	类型	是否可空	含义	备注
//id	Int	N	商品表ID
//content_name	String	N	商品名字
//auto_code	String	N	分类编码
//class	String		分类名称
//content_expiration			保质期
//content_preprice	double	N	售价
//content_shelf	String	N	商品状态
//_content_shelf	int		商品状态值
//specifications	String	N	商品规格
//content_brand	String	N	商品品牌
//content_price	double	N	市场价
//weight	int	N	重量
//specifications	String	N	商品规格
//body[content_mbody]	String	N	商品详情
//show[content_img]	String	N	商品图集
//pro[content_shelf]	int	N	上下架类型	1：上架，2:下架，3补货中

//id	int(11)	N	商品库ID
//content_name	String	N	商品名字
//content_price	decimal(10,2)	N	商品价格
//content_brand  	String	N	品牌
//auto_code	String	N	二级分类编码
//class	String		分类名称
//specifications	String	N	商品规格
//content_self	int		 上下架
//weight	int(11)	N	商品重量
//content_expiration	String	N	保质期
//boby[content_mbody]	String	N	商品详情
//show[content_img]	String	N	商品图集



@property (nonatomic, copy) NSString *seaver_content_shelf;

@property (nonatomic, copy) NSString *unit_price;

@property (nonatomic, copy) NSString *service_name;

@property (nonatomic, copy) NSString *service_type_id;

@property (nonatomic, copy) NSString *service_time;

@property (nonatomic, copy) NSString *serviceper;

@property (nonatomic,copy) NSString * content_body;//商品简介
@end


