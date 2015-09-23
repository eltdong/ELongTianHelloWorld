//
//  TimeModel.h
//  GuoanSeller
//
//  Created by elongtian on 15/9/9.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseModel.h"

@interface TimeModel : BaseModel

@property (nonatomic,copy) NSString *start;

@property (nonatomic,copy) NSString *end;

@property (nonatomic,assign) NSInteger skey;

@property (nonatomic,assign) NSInteger ekey;

@property (nonatomic,assign) NSInteger hold;

@property (nonatomic,assign) NSInteger click;

@end
