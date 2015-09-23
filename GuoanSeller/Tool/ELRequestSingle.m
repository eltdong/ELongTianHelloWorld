//
//  ELRequestSingle.m
//  BaoJianIphone
//
//  Created by elongtian on 15-3-19.
//  Copyright (c) 2015年 madongkai. All rights reserved.
//

#import "ELRequestSingle.h"
#import "ELHttpRequestOperation.h"
#import "BJObject.h"

#import "LoginModel.h"
#import "DataModel.h"
#import "ShopListModel.h"
#import "StatusModel.h"
#import "OrderListModel.h"
#import "OrderModel.h"
#import "CommodityListModel.h"
#import "ClassificationModel.h"
#import "CommodityDetailModel.h"
#import "PeopleModel.h"
#import "DateModel.h"
#import "AddPersonModel.h"
#import "TimeModel.h"
#import "ELTCommentListModel.h"
#import "ELTEshopTime.h"

@implementation ELRequestSingle

#pragma mark - 首页bander图
+ (void)homeBanner_or_ADRequest:(ELRequestSingleCallBack) block{
    [ELHttpRequestOperation getTokenAndTime];
    //http://192.168.1.153/tryy/app/index.php?com=com_appService&method=appSev&app_com=com_app&task=getindexad
    NSString * url = [NSString stringWithFormat:@"%@%@",HTTP,@"&method=appSev&app_com=com_app&task=getindexad"];
//    NSMutableArray * dataArray = [[NSMutableArray alloc]init];
    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc]init];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic         = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSDictionary * datalistDic = [dic objectForKey:@"datalist"];
        NSArray * rollArr          = [datalistDic objectForKey:@"roll"];
        NSArray * scareArr         = [datalistDic objectForKey:@"scare"];
        NSArray * middleArr        = [datalistDic objectForKey:@"middle"];
        NSArray * proctgArr        = [datalistDic objectForKey:@"proctg"];
        NSArray * arr = @[rollArr,scareArr,middleArr,proctgArr];
        for(int i = 0;i<arr.count;i++){
            NSArray * dataArr = arr[i];
            NSMutableArray * objectArr = [[NSMutableArray alloc]init];
            for(NSDictionary * dic in dataArr) {
                BJObject * object   = [[BJObject alloc]init];
                object.auto_id      = OBJC([dic objectForKey:@"auto_id"]);
                object.optionid     = OBJC([dic objectForKey:@"optionid"]);
                object.content_img  = OBJC([dic objectForKey:@"content_value"]);
                object.content_link = OBJC([dic objectForKey:@"content_link"]);
                object.series       = OBJC([dic objectForKey:@"series"]);
                [objectArr addObject:object];
            }
            [dataDic setObject:objectArr forKey:[NSString stringWithFormat:@"%d",i]];
        }
        if(block){
            block(YES,dataDic);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - 定位
+ (void)getlocationDownRequest{
    //http://192.168.1.153/tryy/app/index.php?com=com_appService&method=appSev&app_com=com_app&task=getlocation
    [ELHttpRequestOperation getTokenAndTime];
    NSString * url = [NSString stringWithFormat:@"%@%@",HTTP,@"&method=appSev&app_com=com_app&task=getlocation"];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        [[NSUserDefaults standardUserDefaults]setObject:[[dic objectForKey:@"data"]objectForKey:@"modules_name"] forKey:@"city_name"];
        [[NSUserDefaults standardUserDefaults]setObject:[[dic objectForKey:@"data"]objectForKey:@"auto_code"] forKey:@"city_code"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

#pragma mark - 产品列表
+ (void)typeListWithRequest:(ELRequestSingleCallBack)block andAuto_code:(NSString *)auto_code andSort:(NSString *)sort andPage:(NSString *)page andUrl:(NSString *)screenUrl andKeyword:(NSString *)keyword{
    [ELHttpRequestOperation getTokenAndTime];
    //http://192.168.1.153/tryy/app/index.php?com=com_appService&method=appSev&app_com=com_appshop&task=plists&auto_code=1003&sort=3
    /*
     keyword  搜索
     auto_id  分类
     screeUrl 筛选
     */
    NSString * url;
    if (keyword != nil && auto_code != nil) {
        url = [NSString stringWithFormat:@"%@%@&page=%@&keyword=%@",HTTP,@"&method=appSev&app_com=com_appshop&task=plists",page,keyword];
    }else if(auto_code != nil && keyword == nil){
        url = [NSString stringWithFormat:@"%@%@&auto_code=%@&sort=%@&page=%@%@",HTTP,@"&method=appSev&app_com=com_appshop&task=plists",auto_code,sort,page,screenUrl];
    }else{
       url = [NSString stringWithFormat:@"%@%@&page=%@&sort=%@%@",HTTP,@"&method=appSev&app_com=com_appshop&task=plists",page,sort,screenUrl];
    }
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic       = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSMutableArray * dataArr = [[NSMutableArray alloc]init];
        NSArray * datalistArr    = [dic objectForKey:@"datalist"];
        for (NSDictionary * dataDic in datalistArr) {
            BJObject * object = [[BJObject alloc]init];
            object.auto_id          = OBJC([dataDic objectForKey:@"auto_id"]);
            object.optionid         = OBJC([dataDic objectForKey:@"optionid"]);
            object.content_img      = OBJC([dataDic objectForKey:@"content_img"]);
            object.content_price    = OBJC([dataDic objectForKey:@"content_price"]);
            object.content_desc     = OBJC([dataDic objectForKey:@"content_desc"]);
            object.content_preprice = OBJC([dataDic objectForKey:@"content_preprice"]);
            object.content_word     = OBJC([dataDic objectForKey:@"content_word"]);
            object.content_name     = OBJC([dataDic objectForKey:@"content_name"]);
            [dataArr addObject:object];
        }
        if(block){
            block(YES,dataArr);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


#pragma mark - 产品详情
+ (void)typeDetailWithRequest:(ELRequestSingleCallBack)block andAuto_code:(NSString *)auto_code andAuto_id:(NSString *)auto_id{
    [ELHttpRequestOperation getTokenAndTime];
    //http://192.168.1.153/tryy/app/index.php?com=com_appService&method=appSev&app_com=com_appshop&task=pview&auto_code=1002&auto_id=3
    NSString * url = [NSString stringWithFormat:@"%@%@&auto_code=%@&auto_id=%@",HTTP,@"&method=appSev&app_com=com_appshop&task=pview",auto_code,auto_id];

    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
//        NSMutableArray * dataArr = [[NSMutableArray alloc]init];
        NSDictionary * datalistDic = [dic objectForKey:@"datalist"];
        BJObject * object = [[BJObject alloc]init];
        object.picture          = OBJC([datalistDic objectForKey:@"picture"]);
        object.content_price    = OBJC([datalistDic objectForKey:@"content_price"]);
        object.content_preprice = OBJC([datalistDic objectForKey:@"content_preprice"]);
        object.content_name     = OBJC([datalistDic objectForKey:@"content_name"]);
        object.content_desc     = OBJC([datalistDic objectForKey:@"content_desc"]);
        if(block){
            block(YES,object);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark - 结算 刷新购物车
+ (void)confirmShoppingWithRequest:(ELRequestSingleCallBack)block andID:(NSString *)ID andPWD:(NSString *)pwd andDatum:(NSString *)datum{
    [ELHttpRequestOperation getTokenAndTime];
    //http://192.168.1.153/tryy/app/index.php?com=com_appService&method=save&app_com=com_shopcart&task=app_addCart&ID=elongtian&PWD=e10adc3949ba59abbe56e057f20f883e&datum=W3siYXV0b19pZCI6MTUsIm51bSI6MX0seyJhdXRvX2lkIjoyOSwibnVtIjoxfSx7ImF1dG9faWQiOjMxLCJudW0iOjF9LHsiYXV0b19pZCI6MzMsIm51bSI6MX0seyJhdXRvX2lkIjozMiwibnVtIjoxfV0=
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&datum=%@",HTTP,@"&method=save&app_com=com_shopcart&task=app_addCart",ID,pwd,datum];
    
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        //        NSMutableArray * dataArr = [[NSMutableArray alloc]init];
        NSDictionary * datalistDic = [dic objectForKey:@"data"];
        BJObject * object    = [[BJObject alloc]init];
        object.picture       = [NSMutableArray array];
        object.content_price = [OBJC([datalistDic objectForKey:@"totalspay"]) stringValue];
        object.auto_id       = [OBJC([datalistDic objectForKey:@"appid"])stringValue];
        for (NSDictionary * dic in OBJC([datalistDic objectForKey:@"data"])) {
            BJObject * obj       = [[BJObject alloc]init];
            obj.content_preprice = OBJC([dic objectForKey:@"s_price"]);
            obj.content_img      = OBJC([dic objectForKey:@"c_simg"]);
            obj.content_name     = OBJC([dic objectForKey:@"c_pname"]);
            obj.count            = [OBJC([dic objectForKey:@"c_num"]) stringValue];
            [object.picture addObject:obj];
        }
        if(block){
            block(YES,object);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark - 收货地址
//default=1是默认收货地址
+ (void)addressWithRequest:(ELRequestSingleCallBack)block andID:(NSString *)ID andPWD:(NSString *)pwd andDefault:(NSString *)default1{
    [ELHttpRequestOperation getTokenAndTime];
//    收货地址列表：
//http://192.168.1.153/tryy/app/index.php?com=com_appService&method=appSev&app_com=com_appcenter&task=addrlist&ID=elongtian&PWD=e10adc3949ba59abbe56e057f20f883e
//    获取默认收货地址：
//http://192.168.1.153/tryy/app/index.php?com=com_appService&method=appSev&app_com=com_appcenter&task=addrlist&ID=elongtian&PWD=e10adc3949ba59abbe56e057f20f883e&default=1
    NSString * url;
    if (default1 != nil) {
        url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&default=%@",HTTP,@"&method=appSev&app_com=com_appcenter&task=addrlist",ID,pwd,default1];
    }else{
        url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@",HTTP,@"&method=appSev&app_com=com_appcenter&task=addrlist",ID,pwd];
    }
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSMutableArray * dataArr    = [dic objectForKey:@"datalist"];
        NSMutableArray * contentArr = [NSMutableArray array];
        for (NSDictionary * dic in dataArr) {
            BJObject * object   = [[BJObject alloc]init];
            object.auto_id      = OBJC([dic objectForKey:@"auto_id"]);
            object.content_name = OBJC([dic objectForKey:@"content_name"]);
            object.address      = OBJC([dic objectForKey:@"content_addr"]);
            object.content_tel  = OBJC([dic objectForKey:@"content_mobile"]);
            object.default_addr = OBJC([dic objectForKey:@"default_addr"]);
            object.content_word = OBJC([dic objectForKey:@"content_area_code"]);
            [contentArr addObject:object];
        }
        if(block){
            block(YES,contentArr);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark - 提交订单
+ (void)confirmOrderWithRequest:(ELRequestSingleCallBack)block andID:(NSString *)ID andPWD:(NSString *)pwd andDatum:(NSString *)datum andAppid:(NSString *)appid{
    [ELHttpRequestOperation getTokenAndTime];
    //http://192.168.1.153/tryy/app/index.php?com=com_appService&method=save&app_com=com_shoporder&task=app_addOrder&ID=elongtian&PWD=e10adc3949ba59abbe56e057f20f883e&appid=1402475235&datum=eyJhZGRyZXNzIjoxNywicGF5dHlwZSI6MSwiaW52b2ljZV90eXBlIjoxLCJpbnZvYyI6eyJpbnZvaWNlX2hlYWQiOiJcdTUxNmNcdTUzZjgiLCJpbnZvaWNlX25hbWUiOiJcdTUzMTdcdTRlYWNcdTY2MTNcdTlmOTlcdTU5MjlcdTdmNTEiLCJpbnZvaWNlX2JvZHkiOjJ9LCJjYXJ0IjpbeyJhdXRvX2lkIjozLCJudW0iOjF9LHsiYXV0b19pZCI6MTAsIm51bSI6Mn0seyJhdXRvX2lkIjo5LCJudW0iOjF9LHsiYXV0b19pZCI6NywibnVtIjoxfV19
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&appid=%@&datum=%@",HTTP,@"&method=save&app_com=com_shoporder&task=app_addOrder",ID,pwd,appid,datum];
    
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);

        BJObject * obj     = [[BJObject alloc]init];
        obj.status         = OBJC([dic objectForKey:@"status"]);
        obj.msg            = OBJC([dic objectForKey:@"msg"]);
        obj.content_name   = OBJC([dic objectForKey:@"data"]);
        if(block){
            block(YES,obj);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark - 登录
+ (void)loginWithRequest:(ELRequestSingleCallBack)block andID:(NSString *)ID andPWD:(NSString *)pwd{
//    http://192.168.1.153/tryy/app/index.php?com=com_appService&method=save&app_com=com_passport&task=app_doLogin&ID=elongtian&PWD=e10adc3949ba59abbe56e057f20f883e
    
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@",HTTP,@"&method=save&app_com=com_passport&task=app_doLogin",ID,pwd];
    
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        //        NSMutableArray * dataArr = [[NSMutableArray alloc]init];
        BJObject * object = [[BJObject alloc]init];
        object.status     = OBJC([dic objectForKey:@"status"]);
        object.msg        = OBJC([dic objectForKey:@"msg"]);
        if([object.status isEqualToString:@"1"]){
            NSDictionary * datalistDic = [dic objectForKey:@"data"];
            object.auto_id      = OBJC([datalistDic objectForKey:@"s_id"]);
            object.content_name = OBJC([datalistDic objectForKey:@"m_user"]);
        }
        if(block){
            block(YES,object);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark - 注册
+ (void)registerWithRequest:(ELRequestSingleCallBack)block andID:(NSString *)ID andPWD:(NSString *)pwd andCode:(NSString *)code{
    //http://192.168.1.153/tryy/app/index.php?com=com_appService&method=save&app_com=com_passport&task=app_register&UID=elongtian3&PWD=e10adc3949ba59abbe56e057f20f883e&code=132132
    NSString * url = [NSString stringWithFormat:@"%@%@&UID=%@&PWD=%@&code=%@",HTTP,@"&method=save&app_com=com_passport&task=app_register",ID,pwd,code];
    
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        BJObject * object = [[BJObject alloc]init];
        object.status     = [OBJC([dic objectForKey:@"status"]) stringValue];
        object.msg        = OBJC([dic objectForKey:@"msg"]);
        if([object.status isEqualToString:@"1"]){
            NSDictionary * datalistDic = [dic objectForKey:@"data"];
            object.auto_id      = OBJC([datalistDic objectForKey:@"s_id"]);
            object.content_name = OBJC([datalistDic objectForKey:@"m_user"]);
        }
        if(block){
            block(YES,object);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark - 注册发送验证码
+ (void)registerCodeWithRequest:(ELRequestSingleCallBack)block andPhone:(NSString *)phone{
    //http://192.168.1.153/tryy/app/index.php?com=com_appService&method=save&app_com=com_passport&task=app_regCode&ID=13211111111
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@",HTTP,@"&method=save&app_com=com_passport&task=app_regCode",phone];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        //        NSMutableArray * dataArr = [[NSMutableArray alloc]init];
        BJObject * object = [[BJObject alloc]init];
        object.status     = OBJC([dic objectForKey:@"status"]);
        object.msg        = OBJC([dic objectForKey:@"msg"]);
        if(block){
            block(YES,object);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - 订单列表
+ (void)orderListWithRequest:(ELRequestSingleCallBack)block andID:(NSString *)ID andPWD:(NSString *)pwd{
    
    //http://192.168.1.153/tryy/app/index.php?com=com_appService&method=appSev&app_com=com_appcenter&task=orderlist&ID=elongtian&PWD=e10adc3949ba59abbe56e057f20f883e
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@",HTTP,@"&method=appSev&app_com=com_appcenter&task=orderlist",ID,pwd];
    
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSMutableArray * dataArr = [dic objectForKey:@"datalist"];
        NSMutableArray * contentArr = [NSMutableArray array];
        for (NSDictionary * dic in dataArr) {
            BJObject * object    = [[BJObject alloc]init];
            object.auto_id       = OBJC([dic objectForKey:@"auto_id"]);
            object.content_name  = OBJC([dic objectForKey:@"content_name"]);
            object.status        = OBJC([dic objectForKey:@"content_status"]);
            object.content_price = OBJC([dic objectForKey:@"content_realPay"]);
            object.pay           = OBJC([dic objectForKey:@"content_pay"]);
            object.payment       = OBJC([dic objectForKey:@"content_payment"]);
            object.number        = OBJC([dic objectForKey:@"content_sn"]);
            object.picture       = [NSMutableArray array];
            for (NSDictionary * proDic in OBJC([dic objectForKey:@"modules_sub"])) {
                BJObject * obj    = [[BJObject alloc]init];
                obj.content_name  = OBJC([proDic objectForKey:@"content_name"]);
                obj.content_img   = OBJC([proDic objectForKey:@"content_img"]);
                obj.content_price = OBJC([proDic objectForKey:@"return_price"]);
                obj.auto_id       = OBJC([dic objectForKey:@"auto_id"]);
                [object.picture addObject:obj];
            }
            [contentArr addObject:object];
        }
        if(block){
            block(YES,contentArr);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark - 取消订单
+ (void)cancleOrderWithRequest:(ELRequestSingleCallBack)block andID:(NSString *)ID andPWD:(NSString *)pwd andAuto_id:(NSString *)auto_id{
    
    //http://192.168.1.159/tryy/app/index.php?com=com_appService&method=appSev&app_com=com_appcenter&task=appCancelOrder&auto_id=306&ID=elongtian&PWD=e10adc3949ba59abbe56e057f20f883e
    NSString * url = [NSString stringWithFormat:@"%@%@&auto_id=%@&ID=%@&PWD=%@",HTTP,@"&method=appSev&app_com=com_appcenter&task=appCancelOrder",auto_id,ID,pwd];
    
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        BJObject * object    = [[BJObject alloc]init];
        object.status        = OBJC([dic objectForKey:@"status"]);
        object.msg  = OBJC([dic objectForKey:@"msg"]);
        if(block){
            block(YES,object);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



#pragma mark - 订单详情
+ (void)orderDetailWithRequest:(ELRequestSingleCallBack)block andID:(NSString *)ID andPWD:(NSString *)pwd andAuto_id:(NSString *)auto_id{
    
    //http://192.168.1.153/tryy/app/index.php?com=com_appService&method=appSev&app_com=com_appcenter&task=orderview&auto_id=290&ID=elongtian&PWD=e10adc3949ba59abbe56e057f20f883e
    NSString * url = [NSString stringWithFormat:@"%@%@&auto_id=%@&ID=%@&PWD=%@",HTTP,@"&method=appSev&app_com=com_appcenter&task=orderview",auto_id,ID,pwd];
    
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
//        NSMutableArray * contentArr = [NSMutableArray array];
        NSDictionary * datadic = [dic objectForKey:@"order"];
        BJObject * object    = [[BJObject alloc]init];
        object.auto_id       = OBJC([datadic objectForKey:@"auto_id"]);
        object.content_name  = OBJC([datadic objectForKey:@"content_name"]);
        object.status        = OBJC([datadic objectForKey:@"content_status_label"]);
        object.content_price = OBJC([datadic objectForKey:@"content_realPay"]);
        object.pay           = OBJC([datadic objectForKey:@"is_pay_label"]);
        object.number        = OBJC([datadic objectForKey:@"content_sn"]);
        object.create_time   = OBJC([datadic objectForKey:@"create_time"]);
        object.payment = OBJC([[dic objectForKey:@"paytype"] objectForKey:@"content_name"]);
        object.express = OBJC([[dic objectForKey:@"express"] objectForKey:@"content_name"]);
        
        object.picture = [NSMutableArray array];
        for (NSDictionary * proDic in OBJC([dic objectForKey:@"pro_list"])) {
            BJObject * obj    = [[BJObject alloc]init];
            obj.content_name  = OBJC([proDic objectForKey:@"content_name"]);
            obj.content_img   = OBJC([proDic objectForKey:@"content_img"]);
            obj.content_price = OBJC([proDic objectForKey:@"return_price"]);
            obj.auto_id       = OBJC([dic objectForKey:@"auto_id"]);
            [object.picture addObject:obj];
        }
        if(block){
            block(YES,object);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - 筛选
+ (void)screenRequestWithBlock:(ELRequestSingleCallBack)block andAuto_code:(NSString *)auto_code{
//    http://192.168.1.153/tryy/app/index.php?com=com_appService&method=appSev&app_com=com_appshop&task=psearch&auto_code=100210001000
    NSString * url = [NSString stringWithFormat:@"%@%@&auto_code=%@",HTTP,@"&method=appSev&app_com=com_appshop&task=psearch",auto_code];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dataDic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSArray * typeArr = [dataDic objectForKey:@"datalist"];
        NSMutableArray * dataArr = [NSMutableArray array];
        for (NSDictionary * dic in typeArr) {
            BJObject * object = [[BJObject alloc]init];
            object.content_name = OBJC([dic objectForKey:@"label"]);
            object.picture = [NSMutableArray array];
            for (NSDictionary * subDic in OBJC([dic objectForKey:@"sub"])) {
                BJObject * obj = [[BJObject alloc]init];
                obj.content_name = OBJC([subDic objectForKey:@"label"]);
                obj.content_value = OBJC([subDic objectForKey:@"value"]);
                obj.vars = OBJC([subDic objectForKey:@"vars"]);
                [object.picture addObject:obj];
            }
            [dataArr addObject:object];
        }
        if (block) {
            block(YES,dataArr);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - 分类
+ (void)typeRequestWithBlock:(ELRequestSingleCallBack)block{
    //http://192.168.1.153/tryy/app/index.php?com=com_appService&method=appSev&app_com=com_appshop&task=pctglist
    NSString * url = [NSString stringWithFormat:@"%@%@",HTTP,@"&method=appSev&app_com=com_appshop&task=pctglist"];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray * typeArr = (NSArray *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        //        NSArray * typeArr = [dataDic objectForKey:@"datalist"];
        NSMutableArray * dataArr = [NSMutableArray array];
        for (NSDictionary * dic in typeArr) {
            BJObject * object = [[BJObject alloc]init];
            object.content_name = OBJC([dic objectForKey:@"modules_name"]);
            object.auto_id = OBJC([dic objectForKey:@"auto_id"]);
//            object.picture = OBJC([dic objectForKey:@"modules_sub"]);
            object.picture = [NSMutableArray array];
            for (NSDictionary * subDic in OBJC([dic objectForKey:@"modules_sub"])) {
                BJObject * obj = [[BJObject alloc]init];
                obj.auto_id = OBJC([subDic objectForKey:@"auto_id"]);
                obj.auto_code = OBJC([subDic objectForKey:@"auto_code"]);
                obj.content_name = OBJC([subDic objectForKey:@"modules_name"]);
                obj.content_img = OBJC([subDic objectForKey:@"content_img"]);
                //                obj.vars = OBJC([subDic objectForKey:@"vars"]);
                [object.picture addObject:obj];
            }
            [dataArr addObject:object];
        }
        if (block) {
            block(YES,dataArr);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark - 修改 添加 删除地址
+ (void)alterAddressRequestWithBlock:(ELRequestSingleCallBack)block andTask:(NSString *)task andName:(NSString *)name andArea:(NSString *)area andAddress:(NSString *)address andTel:(NSString *)tel andMobile:(NSString *)mobile andAuto_id:(NSString *)auto_id andDefault:(NSString *)default_addr andUser:(NSString *)user andPwd:(NSString *)pwd{
    //http://192.168.1.153/tryy/app/index.php?com=com_appService&method=save&app_com=com_appcenter&task=editAddr&frm[content_name]=aaaaaaaa&frm[content_area]=10001000&frm[content_addr]=%B2%E2%CA%D4%B5%D8%D6%B72&frm[content_tel]=010-56565656&frm[content_mobile]=13212121212&auto_id=8&frm[default_addr]=1&ID=elongtian&PWD=e10adc3949ba59abbe56e057f20f883e
    /*task = editAddr 修改
              appAddAddr 添加
             app_delAddr 删除
     */
    NSString * url;
    if(name == nil){
        //删除
       url = [NSString stringWithFormat:@"%@%@&task=%@&auto_id=%@&ID=%@&PWD=%@",HTTP,@"&method=save&app_com=com_appcenter",task,auto_id,user,pwd];
    }else{
        url = [NSString stringWithFormat:@"%@%@&task=%@&frm[content_name]=%@&frm[content_area]=%@&frm[content_addr]=%@&frm[content_tel]=%@&frm[content_mobile]=%@&auto_id=%@&frm[default_addr]=%@&ID=%@&PWD=%@",HTTP,@"&method=save&app_com=com_appcenter",task,name,area,address,tel,mobile,auto_id,default_addr,user,pwd];
    }
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        BJObject * object = [[BJObject alloc]init];
        object.status = OBJC([[dic objectForKey:@"status"] stringValue]);
        object.msg = OBJC([dic objectForKey:@"msg"]);
        if (object.msg == nil) {
            object.msg = OBJC([dic objectForKey:@"data"]);
        }
        if (block) {
            block(YES,object);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}













#pragma mark - 修改 地址地区
+ (void)areaAddressRequestWithBlock:(ELRequestSingleCallBack)block{
    //http://192.168.1.159/tryy/app/index.php?com=com_appService&method=appSev&app_com=com_appshop&task=getcitylists
    NSString * url = [NSString stringWithFormat:@"%@%@",HTTP,@"&method=appSev&app_com=com_appshop&task=getcitylists"];
 
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSMutableArray * dataArr = [NSMutableArray array];
        for (NSDictionary * datadic in [dic objectForKey:@"datalist"]) {
            BJObject * object = [[BJObject alloc]init];
            object.auto_code = OBJC([datadic objectForKey:@"auto_code"]);
            object.content_name = OBJC([datadic objectForKey:@"modules_name"]);
            object.picture = [NSMutableArray array];
            for (NSDictionary * cityDic in OBJC([datadic objectForKey:@"city"])) {
                BJObject * obj = [[BJObject alloc]init];
                obj.content_name = OBJC([cityDic objectForKey:@"modules_name"]);
                obj.auto_code = OBJC([cityDic objectForKey:@"auto_code"]);
                [object.picture addObject:obj];
            }
            [dataArr addObject:object];
        }
        if (block) {
            block(YES,dataArr);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark - 搜索
+ (void)searchRequestWithBlock:(ELRequestSingleCallBack)block andKeyword:(NSString *)keyword andPage:(NSString *)page{
    //http://192.168.1.153/tryy/app/index.php?com=com_appService&method=appSev&app_com=com_appshop&task=plists&page=1
    NSString * url = [NSString stringWithFormat:@"%@%@&page=%@&keyword=%@",HTTP,@"&method=appSev&app_com=com_appshop&task=plists",page,keyword];
    
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSMutableArray * dataArr = [NSMutableArray array];
        for (NSDictionary * datadic in [dic objectForKey:@"datalist"]) {
            BJObject * object = [[BJObject alloc]init];
            object.auto_code = OBJC([datadic objectForKey:@"auto_code"]);
            object.content_name = OBJC([datadic objectForKey:@"modules_name"]);
            object.picture = [NSMutableArray array];
            for (NSDictionary * cityDic in OBJC([datadic objectForKey:@"city"])) {
                BJObject * obj = [[BJObject alloc]init];
                obj.content_name = OBJC([cityDic objectForKey:@"modules_name"]);
                obj.auto_code = OBJC([cityDic objectForKey:@"auto_code"]);
                [object.picture addObject:obj];
            }
            [dataArr addObject:object];
        }
        if (block) {
            block(YES,dataArr);
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
#pragma mark - 我的关注列表
+ (void)collectListWithRequest:(ELRequestSingleCallBack)block andID:(NSString *)ID andPWD:(NSString *)pwd{
    
    //http://192.168.1.153/tryy/app/index.php?com=com_appService&method=appSev&app_com=com_appcenter&task=profavlist&ID=elongtian&PWD=e10adc3949ba59abbe56e057f20f883e
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@",HTTP,@"&method=appSev&app_com=com_appcenter&task=profavlist",ID,pwd];
    
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSMutableArray * dataArr = [dic objectForKey:@"datalist"];
        NSMutableArray * contentArr = [NSMutableArray array];
        for (NSDictionary * dic1 in dataArr) {
                BJObject * object    = [[BJObject alloc]init];
                object.optionid       = OBJC([dic1 objectForKey:@"auto_id"]);
            if([dic1[@"product"] isKindOfClass:[NSDictionary class]]){
                NSDictionary * dict = [dic1 objectForKey:@"product"];
                
                object.auto_id       = OBJC([dict objectForKey:@"auto_id"]);
                object.content_name  = OBJC([dict objectForKey:@"content_name"]);
                object.status        = OBJC([dict objectForKey:@"content_status"]);
                object.content_price = OBJC([dict objectForKey:@"content_preprice"]);
                object.pay           = OBJC([dict objectForKey:@"content_pay"]);
                object.payment       = OBJC([dict objectForKey:@"content_payment"]);
                object.number        = OBJC([dict objectForKey:@"content_sn"]);
                object.content_simg  = OBJC([dict objectForKey:@"content_simg"]);
                object.content_img   = OBJC([dict objectForKey:@"content_img"]);
                object.content_desc   = OBJC([dict objectForKey:@"content_desc"]);
//                object.picture       = [NSMutableArray array];
//                for (NSDictionary * proDic in OBJC([dic objectForKey:@"modules_sub"])) {
//                    BJObject * obj    = [[BJObject alloc]init];
//                    obj.content_name  = OBJC([proDic objectForKey:@"content_name"]);
//                    obj.content_img   = OBJC([proDic objectForKey:@"content_img"]);
//                    obj.content_price = OBJC([proDic objectForKey:@"return_price"]);
//                    obj.auto_id       = OBJC([dic objectForKey:@"auto_id"]);
//                    [object.picture addObject:obj];
//                }
                [contentArr addObject:object];
            }
        }
        if(block){
            block(YES,contentArr);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
//增加关注商品
+ (void)addCollectListWithRequest:(ELRequestSingleCallBack)block andTask:(NSString *)task andState:(NSInteger )state  andAuto_id:(NSString *)auto_id  andUser:(NSString *)user andPwd:(NSString *)pwd{
    //http://192.168.1.153/tryy/app/index.php?com=com_appService&method=save&app_com=com_appcenter&task=app_addCollect&auto_id=77&ID=elongtian&PWD=e10adc3949ba59abbe56e057f20f883e
    /*task = editAddr 修改
     appAddAddr 添加
     app_delAddr 删除
     */
    NSString * url = [NSString stringWithFormat:@"%@%@&task=%@&auto_id=%@&ID=%@&PWD=%@",HTTP,@"&method=save&app_com=com_appcenter",task,auto_id,user,pwd];
    
    
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        BJObject * object = [[BJObject alloc]init];
        object.status = OBJC([[dic objectForKey:@"status"] stringValue]);
        object.msg = OBJC([dic objectForKey:@"msg"]);
        if (object.msg == nil) {
            object.msg = OBJC([dic objectForKey:@"data"]);
        }
        if (block) {
            block(YES,object);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败了");
    }];
}
//删除关注商品
+ (void)delCollectListWithRequest:(ELRequestSingleCallBack)block andID:(NSString *)ID andPWD:(NSString *)pwd
{
//    http://192.168.1.166/zxga/app/index.php?com=com_appService&method=save&app_com=com_appassport&task=loginNote&ID=18701678653
    
}

#pragma mark - 发送验证码 yd
+(void)loginWithRequest:(ELRequestSingleCallBack)block andID:(NSString *)ID{
//    http://192.168.1.166/zxga/app/index.php?com=com_appService&method=save&app_com=com_appassport&task=loginNote&ID=18701678653
    NSDictionary *dic = @{@"method":@"save",@"app_com":@"com_appassport",@"task":@"loginNote",@"ID":[ID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]};
    
    [[ELHttpRequestOperation sharedClient] POST:HTTP_SUB parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"] ) {
            NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
            //        NSMutableArray * dataArr = [[NSMutableArray alloc]init];
            BJObject * object = [[BJObject alloc]init];
            if ([[dic objectForKey:@"status"] isKindOfClass:[NSString class]]) {
                object.status = OBJC([dic objectForKey:@"status"]);
            } else {
                object.status = OBJC([[dic objectForKey:@"status"] stringValue]);
            }
            
            object.msg = OBJC([dic objectForKey:@"msg"]);
            if(block){
                block(YES,object);
            }

        }
        else{
            if (block) {
                block(NO,[responseObject objectForKey:@"msg"]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(NO,error.localizedDescription);
        } 
    }];
}
#pragma mark - 登陆 yd
+(void)loginWithRequest:(ELRequestSingleCallBack)block andID:(NSString *)ID andVerificationCode:(NSString *)verificationCode{
    [ELHttpRequestOperation getTokenAndTime];
//http://192.168.1.166/zxga/app/index.php?com=com_appService&method=save&app_com=com_appassport&task=dologin&ID=18701678653&sms=987601
    NSDictionary *dic = @{@"method":@"save",@"app_com":@"com_appassport",@"task":@"dologin",@"ID":ID,@"sms":verificationCode};
    NSLog(@"登陆 登陆 %@",dic);

    NSString * url = [NSString stringWithFormat:@"%@&token=%@&time=%@&client=2",HTTP_SUB,NSUserDefaults_Token_Md5,NSUserDefaults_Time];

//    NSString * url = [NSString stringWithFormat:@"%@&token=%@&client=2",HTTP_SUB,NSUserDefaults_Token];
    NSLog(@"登陆 登陆 %@",url);
    [[ELHttpRequestOperation sharedClient] POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"] ) {
            NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
            BJObject * object = [[BJObject alloc]init];
            if ([[dic objectForKey:@"status"] isKindOfClass:[NSString class]]) {
                object.status = OBJC([dic objectForKey:@"status"]);
            } else {
                object.status =  [OBJC([dic objectForKey:@"status"]) stringValue]; ;
            }
            
            [[NSUserDefaults standardUserDefaults]setObject:[[dic objectForKey:@"data"] objectForKey:@"s_id"] forKey:@"member_id"];
            
            object.msg = OBJC([dic objectForKey:@"msg"]);
            if(block){
                block(YES,object);
            }
        }
        else{
            if (block) {
                block(NO,[responseObject objectForKey:@"msg"]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (block) {
            block(NO,error.localizedDescription);
        }
        
    }];
}
#pragma mark - 获取token值 yd
+(void)getTokenWithRequest:(ELRequestSingleCallBack)block andParaDic:(NSMutableDictionary *)paraDic{
//http://192.168.1.166/zxga/app/index.php?com=com_appService&method=createToken&time=1439538851&client=1&device=ZcUULGieGH
    [ELHttpRequestOperation getTokenAndTime];
    NSDictionary *dic = @{@"method":@"createToken"};
    [paraDic addEntriesFromDictionary:dic];
    
    [[ELHttpRequestOperation sharedClient] POST:HTTP parameters:paraDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        //        NSMutableArray * dataArr = [[NSMutableArray alloc]init];
        BJObject * object = [[BJObject alloc]init];
        if ([[dic objectForKey:@"status"] isKindOfClass:[NSString class]]) {
            object.status = OBJC([dic objectForKey:@"status"]);
        } else {
            object.status = OBJC([[dic objectForKey:@"status"] stringValue]);
        }
        
        object.msg = OBJC([dic objectForKey:@"msg"]);
        if ([object.status isEqualToString:@"1"]) {
            object.token = [[dic objectForKey:@"data"] objectForKey:@"token"];
        }
        
        if(block){
            block(YES,object);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"**yd**error:%@",error.localizedDescription);
    }];
}
#pragma mark - 店铺列表 yd
+ (void)shopListWithRequest:(ELRequestSingleCallBack)block andParadict:(NSMutableDictionary *)dataDic{
    [ELHttpRequestOperation getTokenAndTime];
    NSDictionary *dic = @{@"method":@"appSev",@"app_com":@"com_appcorpcenter",@"task":@"eshoplists"};
    NSString *url = [NSString stringWithFormat:@"%@&method=appSev&app_com=com_appcorpcenter&task=eshoplists&page=1",HTTP];
    NSLog(@"店铺列表 店铺列表%@",url);
    [dataDic addEntriesFromDictionary:dic];
    NSLog(@"%@",dataDic);
    NSLog(@"%@",HTTP);
    [[ELHttpRequestOperation sharedClient] POST:HTTP parameters:dataDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"] ) {
            NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
            NSArray *array = [dic objectForKey:@"datalist"];
            NSMutableArray *dataArr = [NSMutableArray array];
            for (NSDictionary *dict in array) {
                [dataArr addObject:[ShopListModel ModelWithDic:dict]];
            }
            
            if (block) {
                block(YES,dataArr);
            }

        }
        else{
            if (block) {
                block(NO,[responseObject objectForKey:@"msg"]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(NO,error.localizedDescription);
        }
    }];
    
}


#pragma mark - 商家中心的店铺信息 yd
+ (void)shopListWithRequest:(ELRequestSingleCallBack)block andshopID:(NSString *)shopID{
    [ELHttpRequestOperation getTokenAndTime];
    NSDictionary *dic = @{@"com":@"com_appService",@"method":@"appSev",@"app_com":@"com_appcorpcenter",@"task":@"eshopinfo",@"shoppe_id":OBJC(shopID)?shopID:@"9"};
    [[ELHttpRequestOperation sharedClient] POST:HTTP parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject responseObject%@",responseObject);
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"] ) {
            NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
            NSDictionary *dict = [dic objectForKey:@"datalist"];
            
            NSMutableArray *dataArr = [NSMutableArray array];
            ShopListModel *model = [[ShopListModel alloc]init];
            
            [model setValuesForKeysWithDictionary:dict];
            model.shopID = dict[@"id"];
            model.is_limit = [[dict objectForKey:@"is_limit"]integerValue];
            [dataArr addObject:model];
            if (block) {
                block(YES,dataArr);
            }
        }
        else{
            if (block) {
                block(NO,[responseObject objectForKey:@"msg"]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (block) {
                block(NO,error.localizedDescription);
            }
    }];
}
#pragma mark - 店铺状态 yd
+(void)shopStatusWithRequest:(ELRequestSingleCallBack)block andShop_iD:(NSString *)shop_id andType:(NSString*)type{
    [ELHttpRequestOperation getTokenAndTime];
//    http://192.168.1.166/zxga/app/index.php?com=com_appService&method=appSev&app_com=com_appcorpcenter&task=editeshop&shoppe_id=2&type=2
//    NSDictionary *dic = @{@"method":@"appSev",@"app_com":@"com_appcorpcenter",@"task":@"eshopswitch",@"shoppe_id":shop_id,@"type":type}; 
    NSString * url = [NSString stringWithFormat:@"%@&method=%@&app_com=%@&task=%@&shoppe_id=%@&type=%@",HTTP,@"save",@"com_appcorpcenter",@"editeshop",shop_id,type];
    [[ELHttpRequestOperation sharedClient]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"] ) {
            if (block) {
                block(YES,[responseObject objectForKey:@"datalist"]);
            }
        }
        else{
            if (block) {
                block(NO,[responseObject objectForKey:@"datalist"]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(NO,error.localizedDescription);
        }
    }];
}
#pragma mark - 订单列表 yd
+(void)orderListWithRequest:(ELRequestSingleCallBack)block andParaDic:(NSMutableDictionary*)paraDic{
    [ELHttpRequestOperation getTokenAndTime];
 
    NSString * httpSec = [NSString stringWithFormat:@"%@&time=%@&token=%@&client=2",HTTP_SUB,NSUserDefaults_Time,NSUserDefaults_Token_Md5];//去掉member_id
//    http://192.168.1.166/zxga/app/index.php?com=com_appService&method=appSev&app_com=com_appcorpcenter&task=serveorderlist&shoppe_id=1
    
    NSString * url = [NSString stringWithFormat:@"%@&method=%@&app_com=%@&task=%@&shoppe_id=%@&order_id=%@&page=%@&row=%@",httpSec,
                      @"appSev",@"com_appcorpcenter",paraDic[@"task"],paraDic[@"shoppe_id"],paraDic[@"order_id"],paraDic[@"page"],paraDic[@"row"]];
    for (NSString  * keyword in paraDic.allKeys) {
        if ([keyword isEqualToString:@"keyword"]) {   
             url = [NSString stringWithFormat:@"%@&method=%@&app_com=%@&task=%@&shoppe_id=%@&keyword=%@&page=%@&row=%@",httpSec,
            @"appSev",@"com_appcorpcenter",paraDic[@"task"],paraDic[@"shoppe_id"],[paraDic[@"keyword"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],paraDic[@"page"],paraDic[@"row"]];
        }
    }
    NSLog(@"%@",url);
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"] ) {
            NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject[@"datalist"]);
            NSMutableArray *dataArr = [NSMutableArray array];
            [dataArr addObject:[OrderListModel ModelWithDic:dic]];
            if (block) {
                block(YES,dataArr);
            }
        }
        else{
            if (block) {
                block(NO,[responseObject objectForKey:@"msg"]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(NO,error.localizedDescription);
        }
    }];
}
#pragma mark - 评论列表
+(void)commentListWithRequest:(ELRequestSingleCallBack)block andParaDic:(NSMutableDictionary*)paraDic{
    [ELHttpRequestOperation getTokenAndTime];
    NSString * httpSec = [NSString stringWithFormat:@"%@&time=%@&token=%@&client=2",HTTP_SUB,NSUserDefaults_Time,NSUserDefaults_Token_Md5];//去掉member_id
//    http://192.168.1.166/zxga/app/index.php?com=com_appService&method=appSev&app_com=com_appcorpcenter&task=commentlist
    NSString * url = [NSString stringWithFormat:@"%@&method=%@&app_com=%@&task=%@&shoppe_id=%@&type=%@&page=%@&row=%@",
                      httpSec,@"appSev",@"com_appcorpcenter",paraDic[@"task"],paraDic[@"shoppe_id"],paraDic[@"type"],paraDic[@"page"],paraDic[@"row"]];
    NSLog(@"yd:%@",url);
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"] ) {
            NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject[@"datalist"]);
            NSMutableArray *dataArr = [NSMutableArray array];
            [dataArr addObject:[ELTCommentListModel ModelWithDic:dic]];
            if (block) {
                block(YES,dataArr);
            }
        }
        else{
            if (block) {
                block(NO,[responseObject objectForKey:@"msg"]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(NO,error.localizedDescription);
        }
    }];
}
#pragma mark - 订单详情 yd
//    http://192.168.1.166/zxga/app/index.php?com=com_appService&method=appSev&app_com=com_appcorpcenter&task=orderview&id=1
+(void)orderDetailWithRequest:(ELRequestSingleCallBack)block andProduct_id:(NSString *)product_id andTask:(NSString*)task {
    [ELHttpRequestOperation getTokenAndTime];
    NSDictionary *dic = @{@"method":@"appSev",@"app_com":@"com_appcorpcenter",@"task":task,@"id":product_id};
    [[ELHttpRequestOperation sharedClient] POST:HTTP parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"] ) {
            NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject[@"datalist"]);
            NSMutableArray *dataArr = [NSMutableArray array];
            [dataArr addObject:[OrderModel ModelWithDic:dic]];
            if (block) {
                block(YES,dataArr);
            }
        }
        else{
            if (block) {
                block(NO,[responseObject objectForKey:@"msg"]);
            }
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(NO,error.localizedDescription);
        }
    }];
}
#pragma mark - 商品列表 yd
+(void)commodityListWithRequest:(ELRequestSingleCallBack)block  andParameters:(NSMutableDictionary *)parmDict andTask:(NSString *)task{
    
    [ELHttpRequestOperation getTokenAndTime];
    
//http://192.168.1.166/zxga/app/index.php?com=com_appService&method=appSev&app_com=com_appcorpcenter&task=prolists&shoppe_id=1
    NSDictionary *dic = @{@"method":@"appSev",@"app_com":@"com_appcorpcenter",@"task":task};
    NSMutableDictionary * dicAll =[NSMutableDictionary dictionaryWithDictionary:dic];
    [dicAll addEntriesFromDictionary:parmDict];

    NSLog(@"yd:%@",HTTP);

    [[ELHttpRequestOperation sharedClient] POST:HTTP parameters:dicAll success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSMutableArray *dataArr = [NSMutableArray array];
        if([task isEqualToString:@"servelists"]){
            
            for (NSDictionary *dict in dic[@"datalist"]) {
                CommodityListModel * model = [[CommodityListModel alloc]init];
                model.commodity_id = OBJC([dict objectForKey:@"id"]);
                model.shoppe_id = OBJC([dict objectForKey:@"eshop_id"]);
                model.member_id = OBJC([dict objectForKey:@"personal_id"]);
                model.price = OBJC([dict objectForKey:@"unit_price"]);
                model.product_id = OBJC([dict objectForKey:@"product_id"]);
                model.content_preprice = OBJC([dict objectForKey:@"promotion_price"]);
                model.content_shelf = OBJC([dict objectForKey:@"content_shelf"]);
                model.content_sale = OBJC([dict objectForKey:@"content_sale"]);
                model.create_time = OBJC([dict objectForKey:@"create_time"]);
                model.content_img = OBJC([dict objectForKey:@"content_img"]);
                model.content_name = OBJC([dict objectForKey:@"service_name"]);
                model.is_self = OBJC([dict objectForKey:@"is_self"]);
                [dataArr addObject:model];
            }
            
//            @property (nonatomic,copy) NSString * commodity_id;//商品ID
//            @property (nonatomic,copy) NSString * pro_id;//产品库ID
//            @property (nonatomic,copy) NSString * auto_code;//商品分类id
//            @property (nonatomic,copy) NSString * member_id;//商家id
//            @property (nonatomic,copy) NSString * shoppe_id;//
////            @property (nonatomic,copy) NSString * is_self;//自营，非自营 0:非自营 1:自营
////            
////#pragma mark - 商品参数 yd
//            @property (nonatomic,copy) NSString * content_img;//商品图片
//            @property (nonatomic,copy) NSString * content_name;//商品名称
//            @property (nonatomic,copy) NSString * content_shelf;//商品状态
//            @property (nonatomic,copy) NSString * product_id;//价格
//            @property (nonatomic,copy) NSString * content_preprice;//售价s
////            @property (nonatomic,copy) NSString * content_sale;//销量
////            @property (nonatomic,copy) NSString * create_time;//添加时间
        }else{
            for (NSDictionary *dict in dic[@"datalist"]) {
                CommodityListModel * model = [[CommodityListModel alloc]init];
                model.commodity_id = OBJC([dict objectForKey:@"id"]);
                model.shoppe_id = OBJC([dict objectForKey:@"shoppe_id"]);
                model.pro_id = OBJC([dict objectForKey:@"pro_id"]);
                model.auto_code = OBJC([dict objectForKey:@"auto_code"]);
                model.content_preprice = OBJC([dict objectForKey:@"content_preprice"]);
                model.content_shelf = OBJC([dict objectForKey:@"content_shelf"]);
                
                model.content_sale = OBJC([dict objectForKey:@"content_sale"]);
                model.create_time = OBJC([dict objectForKey:@"create_time"]);
                model.content_img = OBJC([dict objectForKey:@"content_img"]);
                model.content_name = OBJC([dict objectForKey:@"content_name"]);
                model.product_id = OBJC([dict objectForKey:@"product_id"]);
                model.is_self = OBJC([dict objectForKey:@"is_self"]);
                model.price = OBJC([dict objectForKey:@"content_price"]);
                [dataArr addObject:model];
            }
        }
        if (block) {
            block(YES,dataArr);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark - 商品分类 yd
+(void)classificationWithRequest:(ELRequestSingleCallBack)block andShope_id:(NSString *)shoppe_id andTask:(NSString *)task{
    [ELHttpRequestOperation getTokenAndTime];
//http://192.168.1.166/zxga/app/index.php?com=com_appService&method=appSev&app_com=com_appcorpcenter&task=proclass&shoppe_id=1
//http://192.168.1.166/zxga/app/index.php?com=com_appService&method=appSev&app_com=com_appcorpcenter&task=serveclass
    NSDictionary *dic = @{@"method":@"appSev",@"app_com":@"com_appcorpcenter",@"task":task,@"shoppe_id":shoppe_id};
    
    [[ELHttpRequestOperation sharedClient] POST:HTTP parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
         if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]]  isEqualToString:@"1"]) {
             NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
             NSMutableArray *dataArr = [NSMutableArray array];
             for (NSDictionary *dict in dic[@"datalist"]) {
                 [dataArr addObject:[ClassificationModel ModelWithDic:dict]];
             }
             if (block) {
                 block(YES,dataArr);
             }

         }
         else{
             if (block) {
                  block(NO, responseObject[@"msg"]);
             }
         }
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(NO,error.localizedDescription);
        }
    }];
}
#pragma mark - 商品删除 yd
+(void)commodityDeleteWithRequest:(ELRequestSingleCallBack)block  andParameters:(NSMutableDictionary *)parmDict andTask:(NSString *)task{
    [ELHttpRequestOperation getTokenAndTime];
//http://192.168.1.166/zxga/app/index.php?com=com_appService&method=save&app_com=com_appcorpcenter&task=removepro&id=1
    NSDictionary *dic = @{@"method":@"save",@"app_com":@"com_appcorpcenter",@"task":task};
    NSString * url = [NSString stringWithFormat:@"%@&method=%@&app_com=%@&task=%@&id=%@",HTTP,@"save",@"com_appcorpcenter",task,parmDict[@"id"]];
    NSMutableDictionary * dicAll =[NSMutableDictionary dictionaryWithDictionary:dic];
    [dicAll addEntriesFromDictionary:parmDict];
//    [[ELHttpRequestOperation sharedClient] POST:HTTP parameters:dicAll success:^(AFHTTPRequestOperation *operation, id responseObject) {
//               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",error.localizedDescription);
//    }];
    NSLog(@"*****yd:%@",url);
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *dataArr = [NSMutableArray array];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]]  isEqualToString:@"1"]) {
            [dataArr addObject:@"1"];
        } else{
            [dataArr addObject:@"0"];
        }
        if (block) {
            block(YES,dataArr);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark - 修改自营商品 yd
+(void)changeSelfCommodityWithRequest:(ELRequestSingleCallBack)block andTask:(NSString *)task andParameters:(NSDictionary *)parmDict{
    [ELHttpRequestOperation getTokenAndTime];
//    http://192.168.1.166/zxga/app/index.php?com=com_appService&method=save&app_com=com_appcorpcenter&task=editprobase
//    http://192.168.1.166/zxga/app/index.php?com=com_appService&method=save&app_com=com_appcorpcenter&task=addprobase
    
    NSDictionary *dic = @{@"method":@"save",@"app_com":@"com_appcorpcenter",@"task":task};
    NSMutableDictionary * dicAll =[NSMutableDictionary dictionaryWithDictionary:dic];
    [dicAll addEntriesFromDictionary:parmDict];
//    [dicAll removeObjectForKey:@"img"];
    NSString * url = [NSString stringWithFormat:@"%@&time=%@&token=%@&client=2",HTTP_SUB,NSUserDefaults_Time,NSUserDefaults_Token_Md5];
    [[ELHttpRequestOperation sharedClient] POST:url parameters:dicAll constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]]  isEqualToString:@"1"]) {
            NSLog(@"%@",[responseObject objectForKey:@"msg"]);
            if (block){
                block(YES,[responseObject objectForKey:@"msg"]);
            }
        } else{
            block(NO,[responseObject objectForKey:@"msg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
}
#pragma mark - 获取扫码商品
+ (void)getSweepProductWithRequest:(ELRequestSingleCallBack)block andCode:(NSString *)code{
    [ELHttpRequestOperation getTokenAndTime];
    NSString * url = [NSString stringWithFormat:@"%@%@&bar=%@",HTTP,@"&method=appSev&app_com=com_appcorpcenter&task=findpro",code];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]]  isEqualToString:@"1"]) {
            NSLog(@"%@",[responseObject objectForKey:@"msg"]);
            if (block) {
                block(YES,[CommodityDetailModel ModelWithDic:[dic objectForKey:@"datalist"]]);
                
            }
        } else{
            block(NO,[responseObject objectForKey:@"msg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark - 商品详情 yd
+(void)getCommodityDetailWithRequest:(ELRequestSingleCallBack)block andCommodity_id:(NSString *)commodity_id andTask:(NSString *)task{
    [ELHttpRequestOperation getTokenAndTime];
//    http://192.168.1.166/zxga/app/index.php?com=com_appService&method=appSev&app_com=com_appcorpcenterr&task=proinfo&id=1
    NSDictionary *dic = @{@"method":@"appSev",@"app_com":@"com_appcorpcenter",@"task":task,@"id":commodity_id};
    NSLog(@"%@",HTTP);
    [[ELHttpRequestOperation sharedClient] POST:HTTP parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]]  isEqualToString:@"1"]) {
            //服务
            if ([task isEqualToString:@"serveinfo"]) {
                NSDictionary * dict = OBJC([dic objectForKey:@"datalist"]);
                CommodityDetailModel * commodity = [[CommodityDetailModel alloc]init];
                commodity.seaver_content_shelf = OBJC([dict objectForKey:@"content_shelf"]);
                commodity.content_shelf_status = OBJC([dict objectForKey:@"_content_shelf"]);
                commodity.unit_price = OBJC([dict objectForKey:@"unit_price"]);
                commodity.service_name = OBJC([dict objectForKey:@"service_name"]);
                commodity.service_type_id = OBJC([dict objectForKey:@"service_type_id"]);
                commodity.service_time = OBJC([dict objectForKey:@"service_time"]);
                commodity.serviceper = OBJC([dict objectForKey:@"serviceper"]);
                commodity.classifationName = OBJC([dict objectForKey:@"class"]);
                commodity.content_body =OBJC([dict objectForKey:@"content_body"]);
                commodity.promotion_price = OBJC([dict objectForKey:@"promotion_price"]);
                commodity.show = [NSMutableArray array];
                for (NSDictionary * dic in OBJC([dict objectForKey:@"show"])) {
                    [commodity.show addObject:OBJC([dic objectForKey:@"content_img"])];
                }
                if (block) {
                    block(YES,commodity);
                }
            }
            else{
                if (block) {
                    block(YES,[CommodityDetailModel ModelWithDic:[dic objectForKey:@"datalist"]]);
                }
            }
        } else{
            if (block) {
                block(NO,[responseObject objectForKey:@"msg"]);
            }
        }
        
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (block) {
             block (NO,error.localizedDescription);
         }
    }];
}
#pragma mark - 获取人员列表
+(void)getpeopleListWithRequest:(ELRequestSingleCallBack)block andShoppe_id:(NSString *)shoppe_id andPage:(NSInteger)page{
    [ELHttpRequestOperation getTokenAndTime];
    NSString *url;
    if (page != 0) {
        url = [NSString stringWithFormat:@"%@%@&shoppe_id=%@&page=%ld",HTTP,@"&method=appSev&app_com=com_appcorpcenter&task=serveperson",shoppe_id,page];
    }else{
        url = [NSString stringWithFormat:@"%@%@&shoppe_id=%@",HTTP,@"&method=appSev&app_com=com_appcorpcenter&task=serveperson",shoppe_id];
    }
    
    NSLog(@"获取人员列表 获取人员列表%@",url);
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSMutableArray *dataArr = [NSMutableArray array];
        if ([[dic objectForKey:@"status"] integerValue] == 1) {
            for (NSDictionary * dict in [dic objectForKey:@"datalist"]) {
                PeopleModel * model = [[PeopleModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                model.name = OBJC([dict objectForKey:@"name"]);
                model.photo = OBJC([dict objectForKey:@"photo"]);
                model.peopleID = OBJC([dict objectForKey:@"id"]);
                model.status = OBJC([dict objectForKey:@"status"]);
                [dataArr addObject:model];
            }
            if (block) {
                block(YES,dataArr);
            }
        }else{
            if (block) {
                block(YES,[dic objectForKey:@"msg"]);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma  mark - 添加服务 选择人员 请求人员 列表
+(void)getpeopleListWithRequest:(ELRequestSingleCallBack)block  andParadic:(NSMutableDictionary *)paradic{
    [ELHttpRequestOperation getTokenAndTime];
    NSString * url = [NSString stringWithFormat:@"%@%@&shoppe_id=%@&page=%@&row=%@",HTTP,@"&method=appSev&app_com=com_appcorpcenter&task=serveperson",paradic[@"shoppe_id"],paradic[@"page"],paradic[@"row"]];
    NSLog(@"获取人员列表 获取人员列表%@",url);
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSMutableArray *dataArr = [NSMutableArray array];
        if ([[dic objectForKey:@"status"] integerValue] == 1) {
            for (NSDictionary * dict in [dic objectForKey:@"datalist"]) {
                PeopleModel * model = [[PeopleModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                model.name = OBJC([dict objectForKey:@"name"]);
                model.photo = OBJC([dict objectForKey:@"photo"]);
                model.peopleID = OBJC([dict objectForKey:@"id"]);
                model.status = OBJC([dict objectForKey:@"status"]);
                [dataArr addObject:model];
            }
            if (block) {
                block(YES,dataArr);
            }
        }else{
            if (block) {
                block(NO,[dic objectForKey:@"msg"]);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(NO,error.localizedDescription);
        }
    }];
}
#pragma mark - 获取一周日期
+(void)getDateWithRequest:(ELRequestSingleCallBack)block andShoppe_id:(NSString *)shoppe_id{
    [ELHttpRequestOperation getTokenAndTime];
    NSString * url = [NSString stringWithFormat:@"%@&method=appSev&app_com=com_appcorpcenter&task=getweek&shoppe_id=%@",HTTP,shoppe_id];
    NSLog(@"获取一周日期 获取一周日期%@",url);
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSLog(@"获取一周日期 获取一周日期 %@",dic);
        NSMutableArray *dataArr = [NSMutableArray array];
        //NSLog(@"%@",[dic objectForKey:@"status"]);
        if ([[dic objectForKey:@"status"] integerValue] == 1) {
            for (NSDictionary *dict in [dic objectForKey:@"datalist"]) {
                DateModel *model = [[DateModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [dataArr addObject:model];
            }
            
        }
        if (block) {
            block(YES,dataArr);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];

    
}

#pragma mark -有限资源店铺开关
+(void)isLimitedWithRequest:(ELRequestSingleCallBack)block andShoppe_id:(NSString *)shoppe_id andType:(NSInteger)type{
    [ELHttpRequestOperation getTokenAndTime];
    NSString * url = [NSString stringWithFormat:@"%@&method=appSev&app_com=com_appcorpcenter&task=eshoplimit&shoppe_id=%@&type=%ld",HTTP,shoppe_id,type];
    NSLog(@"有限资源店铺开关 有限资源店铺开关%@",url);
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSLog(@"有限资源店铺开关 有限资源店铺开关 %@",dic);
        //NSMutableArray *dataArr = [NSMutableArray array];
        if ([[dic objectForKey:@"status"] integerValue] == 1) {
            if (block) {
                block(YES,[dic objectForKey:@"msg"]);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
}

#pragma mark -获取人员信息
+(void)getPersonDeatiWithRequest:(ELRequestSingleCallBack)block andId:(NSString *)Id{
    [ELHttpRequestOperation getTokenAndTime];
    NSString * url = [NSString stringWithFormat:@"%@&method=appSev&app_com=com_appcorpcenter&task=personinfo&id=%@",HTTP,Id];
    NSLog(@"获取人员信息 获取人员信息%@",url);
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSLog(@"获取人员信息 获取人员信息 %@",dic);
        if ([[dic objectForKey:@"status"] integerValue] == 1) {
            AddPersonModel *model = [[AddPersonModel alloc]init];
            [model setValuesForKeysWithDictionary:[dic objectForKey:@"datalist"]];
            if (block) {
                block(YES,model);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
}


#pragma mark -修改店铺人员
+(void)editShopPersonWithRequest:(ELRequestSingleCallBack)block andPeson_id:(NSString *)peson_id andEshop_id:(NSString *)eshop_id andName:(NSString *)name andContent_birthday:(NSString *)content_birthday andIdcard_no:(NSString *)idcard_no andContent_place:(NSString *)content_place andMobile:(NSString *)mobile andContent_age:(NSString *)content_age andContent_desc:(NSString *)content_desc andImg:(NSString *)img andSchedule:(NSString *)array{
    [ELHttpRequestOperation getTokenAndTime];
    NSDictionary *dic = @{@"method":@"save",@"app_com":@"com_appcorpcenter",@"task":@"editeshopperson",@"person_id":peson_id,@"per[eshop_id]":eshop_id,@"per[name]":name,@"per[content_birthday]":content_birthday,@"per[idcard_no]":idcard_no,@"per[content_place]":content_place,@"per[mobile]":mobile,@"per[content_age]":content_age,@"per[content_desc]":content_desc,@"img[1]":img,@"schedule":array};
    NSLog(@"修改店铺人员 修改店铺人员 %@",dic);
    
    NSString *url = [NSString stringWithFormat:@"%@&method=save&app_com=com_appcorpcenter&task=editeshopperson&person_id=%@&per[eshop_id]=%@&per[name]=%@&per[content_birthday]=%@&per[idcard_no]=%@&per[content_place]=%@&per[mobile]=%@&per[content_age]=%@&per[content_desc]=%@&img[1]=%@&schedule=%@",HTTP,peson_id,eshop_id,name,content_birthday,idcard_no,content_place,mobile,content_age,content_desc,img,array];
    NSLog(@"修改店铺人员 修改店铺人员 %@",url);
    
    [[ELHttpRequestOperation sharedClient] POST:HTTP parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        if ([[dic objectForKey:@"status"]integerValue] == 1) {
            if (block) {
                block(YES,[dic objectForKey:@"msg"]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
}

#pragma mark -添加店铺人员
+(void)addShopPersonWithRequest:(ELRequestSingleCallBack)block andEshop_id:(NSString *)eshop_id andName:(NSString *)name andContent_birthday:(NSString *)content_birthday andIdcard_no:(NSString *)idcard_no andContent_place:(NSString *)content_place andMobile:(NSString *)mobile andContent_age:(NSString *)content_age andContent_desc:(NSString *)content_desc andImg:(NSString *)img andSchedule:(NSString *)array{
    [ELHttpRequestOperation getTokenAndTime];
    NSDictionary *dic = @{@"method":@"save",@"app_com":@"com_appcorpcenter",@"task":@"addeshopperson",@"per[eshop_id]":eshop_id,@"per[name]":name,@"per[content_birthday]":content_birthday,@"per[idcard_no]":idcard_no,@"per[content_place]":content_place,@"per[mobile]":mobile,@"per[content_age]":content_age,@"per[content_desc]":content_desc,@"img[1]":img,@"schedule":array};
    NSLog(@"修改店铺人员 修改店铺人员 %@",dic);
    
    NSString *url = [NSString stringWithFormat:@"%@&method=save&app_com=com_appcorpcenter&task=addeshopperson&per[eshop_id]=%@&per[name]=%@&per[content_birthday]=%@&per[idcard_no]=%@&per[content_place]=%@&per[mobile]=%@&per[content_age]=%@&per[content_desc]=%@&img[1]=%@&schedule=%@",HTTP,eshop_id,name,content_birthday,idcard_no,content_place,mobile,content_age,content_desc,img,array];
    NSLog(@"添加店铺人员 添加店铺人员 %@",url);
    
    [[ELHttpRequestOperation sharedClient] POST:HTTP parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        if ([[dic objectForKey:@"status"]integerValue] == 1) {
            if (block) {
                block(YES,[dic objectForKey:@"msg"]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
}


#pragma mark - 删除店铺人员
+(void)deletePersonWithRequest:(ELRequestSingleCallBack)block andShoppe_id:(NSString *)shoppe_id andID:(NSString *)ID{
    [ELHttpRequestOperation getTokenAndTime];
    NSString * url = [NSString stringWithFormat:@"%@&method=save&app_com=com_appcorpcenter&task=deleshopperson&shoppe_id=%@&id=%@",HTTP,shoppe_id,ID];
    NSLog(@"删除店铺人员 删除店铺人员 %@",url);
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSLog(@"删除店铺人员 删除店铺人员 %@",dic);
        if ([[dic objectForKey:@"status"] integerValue] == 1) {
            if (block) {
                block(YES,[dic objectForKey:@"msg"]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
}

#pragma mark - 获取店铺人员占用时间
+(void)getShopPersonTimeRequest:(ELRequestSingleCallBack)block andShoppe_id:(NSString *)shoppe_id andSerper_id:(NSString *)serper_id andDate:(NSString *)date{
    [ELHttpRequestOperation getTokenAndTime];
    NSString * url = [NSString stringWithFormat:@"%@&method=appSev&app_com=com_appcorpcenter&task=eshopcalendar&shoppe_id=%@&serper_id=%@&date=%@",HTTP,shoppe_id,serper_id,date];
    NSLog(@"获取店铺人员占用时间 获取店铺人员占用时间 %@",url);
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)([responseObject isEqual:[NSNull null]]?nil:responseObject);
        NSMutableArray *array = [NSMutableArray array];
        NSLog(@"获取店铺人员占用时间 获取店铺人员占用时间 %@",dic);
        if ([[dic objectForKey:@"status"]integerValue] == 1) {
            for (NSDictionary *dict in [dic objectForKey:@"datalist"]) {
                TimeModel *model = [[TimeModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                model.start = [dict objectForKey:@"sDate"];
                model.end = [dict objectForKey:@"eDate"];
                [array addObject:model];
            }
            if (block) {
                block(YES,array);
            }
        }else{
            if (block) {
                block(YES,[dic objectForKey:@"msg"]);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
}
#pragma mark - 开店 提交
+ (void)addEshopRequestWithBlock:(ELRequestSingleCallBack)block andData:(NSDictionary *)dic andWeek:(NSString *)week andRest:(NSString *)rest{
    [ELHttpRequestOperation getTokenAndTime];
    NSString * url = [NSString stringWithFormat:@"%@&method=save&app_com=com_appcorpcenter&task=addeshop&week=%@&rest=%@",HTTP,week,rest];
    ELHttpRequestOperation *sharedClient = nil;
    sharedClient = [ELHttpRequestOperation manager];
    [sharedClient setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [sharedClient setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [[sharedClient responseSerializer] setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [sharedClient POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        JSONDecoder * json = [[JSONDecoder alloc]init];
        NSDictionary * dic1 = [json objectWithData:responseObject];
        NSLog(@"%@",responseObject);
        if ([[dic1 objectForKey:@"status"] integerValue] == 1) {
            if(block){
                block(YES,[dic1 objectForKey:@"eshop_id"]);
            }
        }else{
            if (block) {
                block(NO,[dic1 objectForKey:@"msg"]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


#pragma mark - 营业时间列表
+ (void)getEshopTimeRequestWithBlock:(ELRequestSingleCallBack)block andShoppe_id:(NSString *)shoppe_id andTask:(NSString *)task{
    [ELHttpRequestOperation getTokenAndTime];
//    eshopresttime 休息时间列表
//    eshoptime  营业时间列表
    NSString * url = [NSString stringWithFormat:@"%@%@&task=%@&shoppe_id=%@",HTTP,@"&method=appSev&app_com=com_appcorpcenter",task,shoppe_id];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary * dataDic = responseObject;
        
        if([task isEqualToString:@"eshoptime"]){
            NSMutableArray * dataArr = [NSMutableArray array];
            for (NSDictionary * dic in [dataDic objectForKey:@"datalist"]) {
                ELTEshopTime * eshop = [[ELTEshopTime alloc]init];
                eshop.week = OBJC([dic objectForKey:@"_week"]);
                eshop.open_time = OBJC([dic objectForKey:@"open_time"]);
                eshop.close_time = OBJC([dic objectForKey:@"close_time"]);
                [dataArr addObject:eshop];
            }
            if (block) {
                block(YES,dataArr);
            }
        }else{
            [[ELTDataArr dataArr].dataArrID removeAllObjects];
            NSMutableArray * dataArr = [NSMutableArray array];
            for (NSDictionary * dic in [dataDic objectForKey:@"datalist"]) {
                [dataArr addObject:OBJC([dic objectForKey:@"date"])];
                [[ELTDataArr dataArr].dataArrID addObject:OBJC([dic objectForKey:@"id"])];
            }
            if (block) {
                block(YES,dataArr);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - 设置时间
+ (void)editEshopTimeRequestWithBlock:(ELRequestSingleCallBack)block andShoppe_id:(NSString *)shoppe_id andTask:(NSString *)task andData:(id)dic{
    [ELHttpRequestOperation getTokenAndTime];
//    deleshopresttime  删除休息时间
//    seteshopresttime  修改休息时间
    NSString * url;
    NSDictionary * dataDic = dic;
    if (![dic isKindOfClass:[NSDictionary class]]) {
        url = [NSString stringWithFormat:@"%@%@&week=%@&shoppe_id=%@",HTTP,@"&method=save&app_com=com_appcorpcenter&task=seteshoptime",dic,shoppe_id];
        dataDic = nil;
        [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            if (block) {
                block(YES,[responseObject objectForKey:@"msg"]);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        return;
    }else{
        url = [NSString stringWithFormat:@"%@%@&task=%@&shoppe_id=%@",HTTP,@"&method=save&app_com=com_appcorpcenter",task,shoppe_id];
    }
    
    [[ELHttpRequestOperation sharedClient] POST:url parameters:dataDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if([[responseObject objectForKey:@"status"] integerValue] == 1){
            if ([task isEqualToString:@"seteshopresttime"]) {
                [[ELTDataArr dataArr].dataArrID addObject:[responseObject objectForKey:@"id"]];
            }
            if (block) {
                block(YES,[responseObject objectForKey:@"msg"]);
            }
        }else{
            if (block) {
                block(NO,[responseObject objectForKey:@"msg"]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



#pragma mark - 店铺管理  获取店铺信息
+ (void)getShopDetailRequestWithBlock:(ELRequestSingleCallBack)block andShoppe_id:(NSString *)shoppe_id{
    [ELHttpRequestOperation getTokenAndTime];
    NSString * url = [NSString stringWithFormat:@"%@&method=appSev&app_com=com_appcorpcenter&task=eshopinfo&shoppe_id=%@",HTTP,shoppe_id];
    
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"店铺管理  获取店铺信息 %@",responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (block) {
                block(YES,[responseObject objectForKey:@"datalist"]);
            }
        }else{
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - 修改店铺头像  或者名称
+ (void)modifyShopHeadImageRequestWithBlock:(ELRequestSingleCallBack)block andShoppe_id:(NSString *)shoppe_id andName:(NSString *)name andPhoto:(NSString *)photo{
    [ELHttpRequestOperation getTokenAndTime];
    NSDictionary * dic;
    if (![name isEqualToString:@""]) {
        dic = @{@"method":@"save",@"app_com":@"com_appcorpcenter",@"task":@"editeshop",@"shoppe_id":shoppe_id,@"name":name};
    }else{
        dic = @{@"method":@"save",@"app_com":@"com_appcorpcenter",@"task":@"editeshop",@"shoppe_id":shoppe_id,@"photo":photo};
    }
    
    [[ELHttpRequestOperation sharedClient] POST:HTTP parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"修改店铺头像  或者名称 %@",responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (block) {
                block(YES,[responseObject objectForKey:@"datalist"]);
            }
        }else{
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - 店铺招牌修改
+ (void)modifyShopImageRequestWithBlock:(ELRequestSingleCallBack)block andShoppe_id:(NSString *)shoppe_id andImage:(NSArray *)imageList{
    [ELHttpRequestOperation getTokenAndTime];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:@"save" forKey:@"method"];
    [dic setObject:@"com_appcorpcenter" forKey:@"app_com"];
    [dic setObject:@"seteshopimg" forKey:@"task"];
    [dic setObject:shoppe_id forKey:@"link_id"];
    
    for (int i = 0;i<imageList.count;i++) {
        NSString *image = [imageList objectAtIndex:i];
        NSString *keyString = [NSString stringWithFormat:@"content_img[%d]",i];
        [dic setObject:image forKey:keyString];
    }
    
    [[ELHttpRequestOperation sharedClient] POST:HTTP parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"店铺招牌修改 %@",responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (block) {
                block(YES,responseObject);
            }
        }else{
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - 店铺招牌图片列表
+ (void)shopImageListRequestWithBlock:(ELRequestSingleCallBack)block andLink_id:(NSString *)link_id{
    [ELHttpRequestOperation getTokenAndTime];
    NSString *url = [NSString stringWithFormat:@"%@&method=appSev&app_com=com_appcorpcenter&task=eshopimglist&link_id=%@&plugin=com_shoppe",HTTP,link_id];
    NSLog(@"店铺招牌图片列表 店铺招牌图片列表 %@",url);
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"店铺招牌图片列表 %@",responseObject);
        NSLog(@"%@",[responseObject objectForKey:@"msg"]);
        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (block) {
                block(YES,[responseObject objectForKey:@"datalist"]);
            }
        }else{
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
