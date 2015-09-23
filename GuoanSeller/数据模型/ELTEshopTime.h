//
//  ELTEshopTime.h
//  GuoanSeller
//
//  Created by 易龙天 on 15/9/16.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseModel.h"

@interface ELTEshopTime : BaseModel

@property (nonatomic, copy) NSString * week;
@property (nonatomic, copy) NSString * open_time;
@property (nonatomic, copy) NSString * close_time;

@property (nonatomic, copy) NSString * restID;
@property (nonatomic, copy) NSString * datetime;
@end
