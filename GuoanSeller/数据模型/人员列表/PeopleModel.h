//
//  PeopleModel.h
//  GuoanSeller
//
//  Created by 易龙天 on 15/9/2.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseModel.h"

@interface PeopleModel : BaseModel
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *peopleID;

@property (nonatomic,copy) NSString *sex;//性别
@property (nonatomic,copy) NSString *content_desc;//简介
@property (nonatomic,assign) BOOL isSelected;
@end
