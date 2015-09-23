//
//  ShopListModel.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/13.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseModel.h"

@interface ShopListModel : BaseModel
//datalist =     (
//                {
//                    "business_status" = 1;
//                    "content_img" = "http://192.168.1.166/zxga/file/upload/2015/09/19/1443025194.jpg";
//                    "create_time" = "1970-01-01";
//                    freight = 0;
//                    id = 35;
//                    "is_limit" = 0;
//                    name = "\U963f\U8428\U5fb7\U603b\U7edf";
//                    publish = 0;
//                    recommend = 0;
//                    "send_price" = "<null>";
//                    target = "_self";
//                    type = 20;
//                }
//                );
@property (nonatomic,copy)  NSString * shopID;//店铺ID

@property (nonatomic,copy) NSString *name;//店铺名称

@property (nonatomic,copy) NSString *content_img;//店铺头像
@property (nonatomic,copy) NSString * _business_status;// 营业状态 1营业2不营业  "_business_status" = 1;
@property (nonatomic,copy) NSString * business_status;//   "business_status" = "\U8425\U4e1a";
@property (nonatomic,copy) NSString *publish;//店铺状态   审核状态 0：未审核 1：已审核
@property (nonatomic,copy) NSString *type;//店铺种类  10：服务型  20：商品性
@property (nonatomic,assign) NSInteger is_limit;//是否是有限资源

#pragma mark - 店铺信息详情
//datalist =     {
//    "_business_status" = 1;
//    "business_status" = "\U8425\U4e1a";
//    "content_img" = "http://192.168.1.166/zxga/file/upload/2015/09/19/1443025194.jpg";
//    freight = 0;
//    id = 35;
//    "image_num" = 0;
//    "is_limit" = 0;
//    money = 0;
//    name = "\U963f\U8428\U5fb7\U603b\U7edf";
//    publish = 0;
//    recommend = 0;
//    "send_price" = "<null>";
//    type = 20;
//};
//status = 1;
//
@property (nonatomic,copy) NSString *recommend;
@property (nonatomic,copy) NSString *business;
@property (nonatomic,assign) NSInteger money;//收入
@end
