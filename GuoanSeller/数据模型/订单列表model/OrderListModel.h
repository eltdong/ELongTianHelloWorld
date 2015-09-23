//
//  OrderListModel.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/18.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseModel.h"

@interface OrderListModel : BaseModel
@property (nonatomic,strong)  NSMutableArray * order;// 订单列表
@property (nonatomic,strong)  NSMutableArray * radio;//四个状态
 
@end
