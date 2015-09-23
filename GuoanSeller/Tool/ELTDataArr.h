//
//  ELTDataArr.h
//  GuoanSeller
//
//  Created by 易龙天 on 15/9/17.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELTDataArr : NSObject
@property (retain, nonatomic) NSMutableArray * dataArr;//休息时间

@property (retain, nonatomic) NSMutableArray * dataArrID;//休息时间ID

+ (ELTDataArr *)dataArr;
@end
