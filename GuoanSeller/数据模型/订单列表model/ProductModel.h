//
//  ProductModel.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/18.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseModel.h"

@interface ProductModel : BaseModel

@property (nonatomic,copy) NSString * amount;//商品数量
@property (nonatomic,copy) NSString * unit_price;//交易单价
@property (nonatomic,copy) NSString * commodity_name;//商品名称
@end
