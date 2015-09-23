//
//  ELRequestSingle.h
//  BaoJianIphone
//
//  Created by elongtian on 15-3-19.
//  Copyright (c) 2015年 madongkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Const.h"
typedef void (^ELRequestSingleCallBack) (BOOL sucess,id objc);

@interface ELRequestSingle : NSObject
//首页
+ (void)homeBanner_or_ADRequest:(ELRequestSingleCallBack) block;
//定位
+ (void)getlocationDownRequest;
//产品列表
+ (void)typeListWithRequest:(ELRequestSingleCallBack)block andAuto_code:(NSString *)auto_code andSort:(NSString *)sort andPage:(NSString *)page andUrl:(NSString *)screenUrl andKeyword:(NSString *)keyword;
//产品详情
+ (void)typeDetailWithRequest:(ELRequestSingleCallBack)block andAuto_code:(NSString *)auto_code andAuto_id:(NSString *)auto_id;
//结算 刷新购物车
+ (void)confirmShoppingWithRequest:(ELRequestSingleCallBack)block andID:(NSString *)ID andPWD:(NSString *)pwd andDatum:(NSString *)datum;
//收货地址
+ (void)addressWithRequest:(ELRequestSingleCallBack)block andID:(NSString *)ID andPWD:(NSString *)pwd andDefault:(NSString *)default1;
//提交订单
+ (void)confirmOrderWithRequest:(ELRequestSingleCallBack)block andID:(NSString *)ID andPWD:(NSString *)pwd andDatum:(NSString *)datum andAppid:(NSString *)appid;
//登陆
+ (void)loginWithRequest:(ELRequestSingleCallBack)block andID:(NSString *)ID andPWD:(NSString *)pwd;
//注册
+ (void)registerWithRequest:(ELRequestSingleCallBack)block andID:(NSString *)ID andPWD:(NSString *)pwd andCode:(NSString *)code;
//注册 发送验证码
+ (void)registerCodeWithRequest:(ELRequestSingleCallBack)block andPhone:(NSString *)phone;
//订单列表
+ (void)orderListWithRequest:(ELRequestSingleCallBack)block andID:(NSString *)ID andPWD:(NSString *)pwd;
//取消订单
+ (void)cancleOrderWithRequest:(ELRequestSingleCallBack)block andID:(NSString *)ID andPWD:(NSString *)pwd andAuto_id:(NSString *)auto_id;
//订单详情
+ (void)orderDetailWithRequest:(ELRequestSingleCallBack)block andID:(NSString *)ID andPWD:(NSString *)pwd andAuto_id:(NSString *)auto_id;
//筛选
+ (void)screenRequestWithBlock:(ELRequestSingleCallBack)block andAuto_code:(NSString *)auto_code;
//种类
+ (void)typeRequestWithBlock:(ELRequestSingleCallBack)block;
//修改地址
+ (void)alterAddressRequestWithBlock:(ELRequestSingleCallBack)block andTask:(NSString *)task andName:(NSString *)name andArea:(NSString *)area andAddress:(NSString *)address andTel:(NSString *)tel andMobile:(NSString *)mobile andAuto_id:(NSString *)auto_id andDefault:(NSString *)default_addr andUser:(NSString *)user andPwd:(NSString *)pwd;
//地区
+ (void)areaAddressRequestWithBlock:(ELRequestSingleCallBack)block;
//我的关注列表
+ (void)collectListWithRequest:(ELRequestSingleCallBack)block andID:(NSString *)ID andPWD:(NSString *)pwd;
//增加关注商品
+ (void)addCollectListWithRequest:(ELRequestSingleCallBack)block andTask:(NSString *)task andState:(NSInteger )state  andAuto_id:(NSString *)auto_id  andUser:(NSString *)user andPwd:(NSString *)pwd;
//删除关注商品
+ (void)delCollectListWithRequest:(ELRequestSingleCallBack)block andID:(NSString *)ID andPWD:(NSString *)pwd;

#pragma mark -  发送验证码
+(void)loginWithRequest:(ELRequestSingleCallBack)block andID:(NSString *)ID;
#pragma mark - 登陆
+(void)loginWithRequest:(ELRequestSingleCallBack)block andID:(NSString *)ID andVerificationCode:(NSString *)verificationCode;
#pragma mark - 获取token值
+(void)getTokenWithRequest:(ELRequestSingleCallBack)block andParaDic:(NSMutableDictionary *)paraDic;
#pragma mark - 店铺列表
+ (void)shopListWithRequest:(ELRequestSingleCallBack)block andParadict:(NSMutableDictionary *)dataDic;
#pragma mark - 商家中心的店铺信息 yd
+ (void)shopListWithRequest:(ELRequestSingleCallBack)block andshopID:(NSString *)shopID;
#pragma mark - 店铺状态 yd
+(void)shopStatusWithRequest:(ELRequestSingleCallBack)block andShop_iD:(NSString *)shop_id andType:(NSString*)type;
#pragma mark - 订单列表 yd
+(void)orderListWithRequest:(ELRequestSingleCallBack)block andParaDic:(NSMutableDictionary*)paraDic;
/**
 *  评论列表
 *
 *  @param block   <#block description#>
 *  @param paraDic <#paraDic description#>
 */
+(void)commentListWithRequest:(ELRequestSingleCallBack)block andParaDic:(NSMutableDictionary*)paraDic;
#pragma mark - 订单详情 yd
+(void)orderDetailWithRequest:(ELRequestSingleCallBack)block andProduct_id:(NSString *)product_id andTask:(NSString*)task;
#pragma mark - 商品列表 yd
+(void)commodityListWithRequest:(ELRequestSingleCallBack)block  andParameters:(NSMutableDictionary *)parmDict andTask:(NSString *)task;
#pragma mark - 商品分类 yd
+(void)classificationWithRequest:(ELRequestSingleCallBack)block andShope_id:(NSString *)shoppe_id andTask:(NSString *)task;
#pragma mark - 商品删除 yd
+(void)commodityDeleteWithRequest:(ELRequestSingleCallBack)block  andParameters:(NSMutableDictionary *)parmDict andTask:(NSString *)task;
#pragma mark - 修改自营商品 yd
+(void)changeSelfCommodityWithRequest:(ELRequestSingleCallBack)block andTask:(NSString *)task andParameters:(NSDictionary *)parmDict;
#pragma mark - 商品详情 yd
+(void)getCommodityDetailWithRequest:(ELRequestSingleCallBack)block andCommodity_id:(NSString *)commodity_id andTask:(NSString *)task;
#pragma mark - 获取扫码商品
+ (void)getSweepProductWithRequest:(ELRequestSingleCallBack)block andCode:(NSString *)code;
#pragma mark - 获取人员列表
+(void)getpeopleListWithRequest:(ELRequestSingleCallBack)block andShoppe_id:(NSString *)shoppe_id andPage:(NSInteger)page;
#pragma  mark - 添加服务 选择人员 请求人员 列表 yd
+(void)getpeopleListWithRequest:(ELRequestSingleCallBack)block  andParadic:(NSMutableDictionary *)paradic;

#pragma mark - 获取一周日期
+(void)getDateWithRequest:(ELRequestSingleCallBack)block andShoppe_id:(NSString *)shoppe_id;

#pragma mark -有限资源店铺开关
+(void)isLimitedWithRequest:(ELRequestSingleCallBack)block andShoppe_id:(NSString *)shoppe_id andType:(NSInteger)type;

#pragma mark -获取人员信息
+(void)getPersonDeatiWithRequest:(ELRequestSingleCallBack)block andId:(NSString *)Id;

#pragma mark -修改店铺人员
+(void)editShopPersonWithRequest:(ELRequestSingleCallBack)block andPeson_id:(NSString *)peson_id andEshop_id:(NSString *)eshop_id andName:(NSString *)name andContent_birthday:(NSString *)content_birthday andIdcard_no:(NSString *)idcard_no andContent_place:(NSString *)content_place andMobile:(NSString *)mobile andContent_age:(NSString *)content_age andContent_desc:(NSString *)content_desc andImg:(NSString *)img andSchedule:(NSString *)array;

#pragma mark -添加店铺人员
+(void)addShopPersonWithRequest:(ELRequestSingleCallBack)block andEshop_id:(NSString *)eshop_id andName:(NSString *)name andContent_birthday:(NSString *)content_birthday andIdcard_no:(NSString *)idcard_no andContent_place:(NSString *)content_place andMobile:(NSString *)mobile andContent_age:(NSString *)content_age andContent_desc:(NSString *)content_desc andImg:(NSString *)img andSchedule:(NSString *)array;

#pragma mark - 删除店铺人员
+(void)deletePersonWithRequest:(ELRequestSingleCallBack)block andShoppe_id:(NSString *)shoppe_id andID:(NSString *)ID;

#pragma mark - 获取店铺人员占用时间
+(void)getShopPersonTimeRequest:(ELRequestSingleCallBack)block andShoppe_id:(NSString *)shoppe_id andSerper_id:(NSString *)serper_id andDate:(NSString *)date;

#pragma mark - 开店 提交
+ (void)addEshopRequestWithBlock:(ELRequestSingleCallBack)block andData:(NSDictionary *)dic andWeek:(NSString *)week andRest:(NSString *)rest;

#pragma mark - 营业时间列表
+ (void)getEshopTimeRequestWithBlock:(ELRequestSingleCallBack)block andShoppe_id:(NSString *)shoppe_id andTask:(NSString *)task;
#pragma mark - 设置时间
+ (void)editEshopTimeRequestWithBlock:(ELRequestSingleCallBack)block andShoppe_id:(NSString *)shoppe_id andTask:(NSString *)task andData:(id)dic;

#pragma mark - 店铺管理  获取店铺信息
+ (void)getShopDetailRequestWithBlock:(ELRequestSingleCallBack)block andShoppe_id:(NSString *)shoppe_id;

#pragma mark - 修改店铺头像  或者名称
+ (void)modifyShopHeadImageRequestWithBlock:(ELRequestSingleCallBack)block andShoppe_id:(NSString *)shoppe_id andName:(NSString *)name andPhoto:(NSString *)photo;

#pragma mark - 店铺招牌修改
+ (void)modifyShopImageRequestWithBlock:(ELRequestSingleCallBack)block andShoppe_id:(NSString *)shoppe_id andImage:(NSArray *)imageList;

#pragma mark - 店铺招牌图片列表
+ (void)shopImageListRequestWithBlock:(ELRequestSingleCallBack)block andLink_id:(NSString *)link_id;

@end
