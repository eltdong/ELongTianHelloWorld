//
//  ClassificationModel.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/19.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "ClassificationModel.h"
#import "ClassificationSecModel.h"
@implementation ClassificationModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    [self setValuesForKeysWithDictionary:dic];
    self.sub  = [NSMutableArray array];
    for (NSDictionary * dict in OBJC(dic[@"sub"])) {
        [self.sub addObject:[ClassificationSecModel ModelWithDic:dict]];
    }
    return self;
}
@end
