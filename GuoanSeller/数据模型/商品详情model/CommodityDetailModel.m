//
//  CommodityDetailModel.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/27.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "CommodityDetailModel.h"
#import "ShowModel.h"
@implementation CommodityDetailModel

-(instancetype)initWithDic:(NSDictionary *)dic{
    [self setValuesForKeysWithDictionary:dic];
    _pro_id = OBJC([dic objectForKey:@"id"]);
    _content_shelf_status = OBJC([dic objectForKey:@"_content_shelf"]);
    _member_id = OBJC([dic objectForKey:@"member_id"]);
    _product_id = OBJC([dic objectForKey:@"product_id"]);
    _content_img = OBJC([dic objectForKey:@"content_img"]);
    _shoppe_id = OBJC([dic objectForKey:@"shoppe_id"]);
    _is_self = OBJC([dic objectForKey:@"is_self"]);
    _content_mbody = OBJC([dic objectForKey:@"content_mbody"]);
    _show = OBJC([dic objectForKey:@"show"]);
    _content_shelf = OBJC([dic objectForKey:@"content_shelf"]);
    _specifications = OBJC([dic objectForKey:@"specifications"]);
    _content_expiration = OBJC([dic objectForKey:@"content_expiration"]);
    _weight = OBJC([dic objectForKey:@"weight"]);
    _classifationName = OBJC([dic objectForKey:@"classifationName"]);
    _auto_code = OBJC([dic objectForKey:@"auto_code"]);
    _content_brand = OBJC([dic objectForKey:@"content_brand"]);
    _content_preprice = OBJC([dic objectForKey:@"content_preprice"]);
    _content_price = OBJC([dic objectForKey:@"content_price"]);
    _content_name = OBJC([dic objectForKey:@"content_name"]);



    if ([[dic objectForKey:@"show"]isKindOfClass:[NSArray class]]) {
        self.show = [NSMutableArray array];
        for (NSDictionary * dict in [dic objectForKey:@"show"]) {
            [self.show addObject:[ShowModel ModelWithDic:dict]];
        }
    }
    else{
        
    }
    if ([[dic objectForKey:@"body"] isKindOfClass:[NSDictionary class]]) {
        self.content_mbody = [[dic objectForKey:@"body"] objectForKey:@"content_mbody"];
    }else
    {
        self.content_mbody= @"暂无介绍";
    }
    self.classifationName =  OBJC(dic[@"class"]);
    
    return self;
}
-(void)setSpecifications:(NSString *)specifications{
    if ([specifications isEqualToString:@""]||specifications == NULL) {
        _specifications = @"未添加";
    }else{
        _specifications = specifications;
    }
}


@end


