//
//  orderModel.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/18.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "orderModel.h"
#import "ProductModel.h"
#import "ServiceModel.h"
@implementation OrderModel
-(instancetype)initWithDic:(NSDictionary *)dic{
   
    [self setValuesForKeysWithDictionary:dic];
    self.order_status = OBJCREMARK([dic objectForKey:@"order_status"]);
    self.coupon_price = OBJCNUM([dic objectForKey:@"coupon_price"]);
    self.customer_name = OBJCREMARK([dic objectForKey:@"customer_name"]);//判断null 和@“” 的方法
    self.order_id = dic[@"id"];
//    self.person_name = OBJC();//服务人员名字
    self.person_name = [[dic objectForKey:@"person_name"] isEqual:[NSNull null]] ?(@""):([NSString stringWithFormat:@"%@",[dic objectForKey:@"person_name"]]);
    NSLog(@"%@",[dic objectForKey:@"person_name"]);
    self.pro = [NSMutableArray array];
    
    for (NSDictionary *dict in dic[@"pro"]) {
        [self.pro addObject:[ProductModel ModelWithDic:dict]];
    }
    self.sev = [NSMutableArray array];
    for (NSDictionary * dict  in dic[@"sev"]) {
        [self.sev addObject:[ServiceModel ModelWithDic:dict]];
    }
     
    return self;
} 
-(void)setAddress:(NSString *)address{
    _address = OBJCREMARK(address);
    
}
@end
