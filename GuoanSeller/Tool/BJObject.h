//
//  BJObject.h
//  BaoJianIphone
//
//  Created by 马东凯 on 15/3/16.
//  Copyright (c) 2015年 madongkai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BJObject : NSObject

@property (nonatomic,copy) NSString * token;//yd token值
@property (copy, nonatomic) NSString * member_title;
@property (copy, nonatomic) NSString * member_img;
@property (copy, nonatomic) NSString * member_subtitle;

@property (copy, nonatomic) NSString * modules_name;
@property (copy, nonatomic) NSString * modules_desc;
@property (copy, nonatomic) NSString * auto_id;
@property (copy, nonatomic) NSString * auto_code;
@property (copy, nonatomic) NSString * optionid;
@property (copy, nonatomic) NSString * content_body;
@property (copy, nonatomic) NSString * create_time;
@property (copy, nonatomic) NSString * content_img;
@property (copy, nonatomic) NSString * content_simg;
@property (copy, nonatomic) NSString * content_name;
@property (copy, nonatomic) NSString * content_desc;
@property (copy, nonatomic) NSString * content_tel;
@property (nonatomic, copy) NSString * content_no;
@property (nonatomic, copy) NSString * content_value;
@property (nonatomic, copy) NSString * content_price;
@property (nonatomic, copy) NSString * content_preprice;
@property (nonatomic, copy) NSString * content_word;
//系列
@property (nonatomic, copy) NSString * series;
@property (nonatomic, copy) NSString * content_link;

@property (nonatomic, copy) NSString * count;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * default_addr;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * msg;
@property (nonatomic, copy) NSString * pay;
@property (nonatomic, copy) NSString * payment;
@property (nonatomic, copy) NSString * express;
@property (nonatomic, copy) NSString * number;
@property (nonatomic, copy) NSString * vars;


@property (nonatomic, retain) NSMutableArray * picture;
@end
