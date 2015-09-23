//
//  AddProduct_sweep.h
//  GuoanSeller
//
//  Created by 易龙天 on 15/8/27.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseModel.h"

@interface AddProduct_sweep : BaseModel

@property (nonatomic, copy) NSString *fvID;

@property (nonatomic, copy) NSString *specifications;

@property (nonatomic, copy) NSString *auto_code;

@property (nonatomic, copy) NSString *content_desc;

@property (nonatomic, copy) NSString *content_brand;

@property (nonatomic, copy) NSString *weight;

@property (nonatomic, copy) NSString *content_bar;

@property (nonatomic, copy) NSString *content_name;

@property (nonatomic, copy) NSString *content_expiration;

@property (nonatomic, copy) NSString *is_self;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *content_price;

@property (nonatomic, copy) NSString *content_mbody;

@property (nonatomic, strong) NSMutableArray * imgArr;

@end
