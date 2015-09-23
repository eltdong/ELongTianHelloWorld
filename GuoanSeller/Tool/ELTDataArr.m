//
//  ELTDataArr.m
//  GuoanSeller
//
//  Created by 易龙天 on 15/9/17.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "ELTDataArr.h"

@implementation ELTDataArr

- (id)init
{
    if(self = [super init])
    {
        self.dataArr = [NSMutableArray array];
        self.dataArrID = [NSMutableArray array];
    }
    return self;
}

+ (ELTDataArr *)dataArr{
    static ELTDataArr * manager;
    if(manager == nil)
    {
        manager = [[ELTDataArr alloc] init];
    }
    return manager;//记得这里加同步锁
}
@end
