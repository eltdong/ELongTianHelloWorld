//
//  ServiceModel.h
//  GuoanSeller
//
//  Created by elongtian on 15/9/8.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseModel.h"

@interface ServiceModel : BaseModel
//sev[‘price’]	double(11,0)	N	交易价格
//sev[‘service_name’]	String	N	服务名称
//sev[‘service_id’]	String	N	服务id
//sev[‘service_order_id’]	String	N	服务订单id
@property (nonatomic,copy) NSString * price;//交易价格
@property (nonatomic,copy) NSString * service_name;//服务名称
@property (nonatomic,copy) NSString * service_id;//服务id
@property (nonatomic,copy) NSString * service_order_id;//服务订单id
@end
