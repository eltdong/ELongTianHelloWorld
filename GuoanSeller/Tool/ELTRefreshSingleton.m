//
//  ELTRefreshSingleton.m
//  GuoanSeller
//
//  Created by 易龙天 on 15/9/20.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "ELTRefreshSingleton.h"

@implementation ELTRefreshSingleton
- (id)init
{
    if(self = [super init])
    {
        self.state = NO;
    }
    return self;
}

+ (ELTRefreshSingleton *)refreshIsOK
{
    static ELTRefreshSingleton * manager;
    if(manager == nil)
    {
        manager = [[ELTRefreshSingleton alloc] init];
    }
    return manager;//记得这里加同步锁
}
@end
