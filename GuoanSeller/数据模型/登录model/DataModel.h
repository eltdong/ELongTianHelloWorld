//
//  DataModel.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/26.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseModel.h"

@interface DataModel : BaseModel

    //        "m_email" = "<null>";
    //        "m_level" = 1;
    //        "m_user" = 18231851975;
    //        "s_id" = 60;
    //        "s_type" = 2;
    //    };
@property (nonatomic,assign) NSInteger m_user;//手机号
@property (nonatomic,assign) NSInteger s_id;//商家id
@property (nonatomic,assign) NSInteger s_type;//1.买家端 2.卖家端
@end
