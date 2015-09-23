//
//  BaseModel.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/13.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject
+(instancetype)ModelWithDic:(NSDictionary * )dic;
-(instancetype)initWithDic:(NSDictionary * )dic;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * msg;
@end
