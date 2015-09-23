//
//  BaseModel.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/13.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+(instancetype)ModelWithDic:(NSDictionary * )dic
{
    return [[self alloc]initWithDic:dic];
}
-(instancetype)initWithDic:(NSDictionary * )dic{
    
    [self setValuesForKeysWithDictionary:dic];
    return self;
}
@end
