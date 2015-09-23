//
//  ShopListModel.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/13.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "ShopListModel.h"

@implementation ShopListModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    [self setValuesForKeysWithDictionary:dic];
     self.shopID = dic[@"id"];
//    @property (nonatomic,copy)  NSString * shopID;//店铺ID
//    
//    @property (nonatomic,copy) NSString *name;//店铺名称
//    
//    @property (nonatomic,copy) NSString *content_img;//店铺头像
//    @property (nonatomic,copy) NSString * _business_status;// 营业状态 1营业2不营业  "_business_status" = 1;
//    @property (nonatomic,copy) NSString * business_status;//   "business_status" = "\U8425\U4e1a";
//    @property (nonatomic,copy) NSString *publish;//店铺状态   审核状态 0：未审核 1：已审核
//    @property (nonatomic,copy) NSString *type;//店铺种类  10：服务型  20：商品性
//    @property (nonatomic,assign) NSInteger is_limit;//是否是有限资源
//    
//#pragma mark - 店铺信息详情
//    @property (nonatomic,copy) NSString *recommend;
//    @property (nonatomic,copy) NSString *business;
//    @property (nonatomic,copy) NSString *money;
    
    
    
    
    
    
    
    
    
    self.money = [NSString stringWithFormat:@"%.2lf",[OBJCNUM(dic[@"money"]) doubleValue]];
    return self;
}
@end
