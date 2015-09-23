//
//  ELTCommentListModel.h
//  GuoanSeller
//
//  Created by elongtian on 15/9/15.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseModel.h"

@interface ELTCommentListModel : BaseModel 
@property (nonatomic,strong)  NSMutableArray * review;// 订单列表
@property (nonatomic,strong)  NSMutableArray * radio;//四个状态
@end
