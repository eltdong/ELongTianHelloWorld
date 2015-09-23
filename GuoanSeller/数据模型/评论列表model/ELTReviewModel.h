//
//  ELTReviewModel.h
//  GuoanSeller
//
//  Created by elongtian on 15/9/15.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseModel.h"

@interface ELTReviewModel : BaseModel 
@property (nonatomic,copy) NSString * evaluation_value;//评论类型值
@property (nonatomic,copy) NSString * service_name;//评论对象名称
@property (nonatomic,copy) NSString * evaluation_content;//评论内容
@property (nonatomic,copy) NSString * content_user;//评论用户
@property (nonatomic,copy) NSString * create_time;//评论时间
@end
