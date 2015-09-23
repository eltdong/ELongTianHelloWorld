//
//  DateModel.h
//  GuoanSeller
//
//  Created by elongtian on 15/9/8.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseModel.h"

@interface DateModel : BaseModel

@property (nonatomic,copy) NSString *name;//周几

@property (nonatomic,copy) NSString *label;//例如：9月7日

@property (nonatomic,copy) NSString *date;//例如：2015-09-07

@property (nonatomic,assign) NSInteger click;//是否可点击

@end
