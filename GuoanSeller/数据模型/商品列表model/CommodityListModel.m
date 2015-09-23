//
//  CommodityListModel.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/19.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "CommodityListModel.h"

@implementation CommodityListModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    [self setValuesForKeysWithDictionary:dic];
    self.commodity_id = dic[@"id"];
    return self;
}
@end
