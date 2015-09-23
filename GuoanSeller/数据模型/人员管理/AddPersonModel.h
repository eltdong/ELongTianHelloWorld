//
//  AddPersonModel.h
//  GuoanSeller
//
//  Created by elongtian on 15/9/8.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseModel.h"
#import "ZLPhotoAssets.h"

@interface AddPersonModel : BaseModel

@property (nonatomic,copy) NSString *address;//地址

@property (nonatomic,copy) NSString *content_age;//从业年限

@property (nonatomic,copy) NSString *eshop_id;//E店id

@property (nonatomic,copy) NSString *name;//姓名

@property (nonatomic,copy) NSString *idcard_no;//身份证

@property (nonatomic,copy) NSString *mobile;//手机号

@property (nonatomic,copy) NSString *content_birthday;//年龄

@property (nonatomic,copy) NSString *content_place;//籍贯

@property (nonatomic,copy) NSString *content_desc;//人员简介

@property (nonatomic,copy) NSString *photo;//图片路径

@property (nonatomic,strong) ZLPhotoAssets *selectPhoto;

@end
