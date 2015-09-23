//
//  ELTRefreshSingleton.h
//  GuoanSeller
//
//  Created by 易龙天 on 15/9/20.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELTRefreshSingleton : NSObject
@property (assign, nonatomic) BOOL state;//刷新状态   yes 可以刷新  no 不刷新

+ (ELTRefreshSingleton *)refreshIsOK;
@end
