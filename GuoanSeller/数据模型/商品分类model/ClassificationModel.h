//
//  ClassificationModel.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/19.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseModel.h"

@interface ClassificationModel : BaseModel
//"modules_name": "酒类",
//"auto_code": "1000",
//"sub": [
//        {
//            "modules_name": "红酒",
////            "auto_code": "10001000"
@property (nonatomic,copy) NSString * modules_name;//酒类
@property (nonatomic,copy) NSString * auto_code;//1000
@property (nonatomic,strong)  NSMutableArray * sub;
@end
