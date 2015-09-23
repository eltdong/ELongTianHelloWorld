//
//  orderModel.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/18.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseModel.h"

@interface OrderModel : BaseModel
@property (nonatomic,copy) NSString * order_id;//订单Id

@property (nonatomic,copy) NSString * content_sn;//订单编号
@property (nonatomic,copy) NSString * order_status;//订单状态

@property (nonatomic,copy) NSString * consignee;//收货人名称
@property (nonatomic,copy) NSString * consignee_phone;//收货人电话号码
@property (nonatomic,copy) NSString * address;//完整交付地址

@property (nonatomic,copy) NSString * create_time;//下单时间
@property (nonatomic,copy) NSString * total_price;//订单金额
@property (nonatomic,copy) NSString * amount;//数量 --- 暂未定义 yd  （实付）应付金额（订单详情）

@property (nonatomic,copy) NSString * freight;//运费

@property (nonatomic,strong)  NSMutableArray * pro;//产品数组

//person_name			服务人员姓名
//is_limit	int		有限/无限资源	1：无限资源，2：有限资源
//"customer_id": "LINKding-98",
//"coupon_id": "30.00",

//"label": "30.00",
//"value": "28",
#pragma mark - 订单详情和订单列表不同的字段
@property (nonatomic,copy) NSString * pay_time;//付款时间
@property (nonatomic,copy) NSString * order_remarks;//订单备注

//卖家信息
@property (nonatomic,copy) NSString * customer_id;//用户账号== 买家
@property (nonatomic,copy) NSString * customer_name;//买家
@property (nonatomic,copy) NSString * evaluation_comment;//订单备注 （暂定）
//@property (nonatomic,copy) NSString * coupon_id;//代金券价格
@property (nonatomic,copy) NSString * coupon_price;//代金券价格


#pragma mark - 服务列表不同的字段
@property (nonatomic,copy) NSString * is_limit;//有限/无限资源	1：无限资源，2：有限资源
@property (nonatomic,copy) NSString * person_name;//服务人员姓名

@property (nonatomic,strong)  NSMutableArray * sev;
//"appointment_start_time": "2015-09-01 12:45:00",
//"appointment_end_time": "2015-09-01 13:45:00",
@property (nonatomic,copy) NSString * appointment_start_time;//服务开始时间
@property (nonatomic,copy) NSString * appointment_end_time;//服务结束时间
@property (nonatomic,copy) NSString * service_time;//服务时长
#pragma mark - 服务详情 字段
//@property (nonatomic,copy) NSString * personal_name;//服务人员姓名 
@property (nonatomic,copy) NSString * price;// 应付金额


@end
