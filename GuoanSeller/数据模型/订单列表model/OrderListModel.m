//
//  OrderListModel.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/18.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "OrderListModel.h"
#import "OrderModel.h"
#import "RadioModel.h"
@implementation OrderListModel
-(instancetype)initWithDic:(NSDictionary * )dic{
    self.order= [NSMutableArray array];
    self.radio = [NSMutableArray array];
    NSArray * arr = dic.allKeys;
    for (NSInteger i =0 ; i < arr.count; i ++) {
        if ([arr[i] isEqualToString:@"order"]) {
            if (![dic[@"review"] isEqual:[NSNull null]]) {
                for (NSDictionary * dict in dic[@"order"]) {
                    [self.order addObject:[OrderModel ModelWithDic:dict]];
                }
            }
        }
    }
   
        
    for (NSDictionary * dict in OBJC(dic[@"radio"])) {
        [self.radio addObject:[RadioModel ModelWithDic:dict]];
    }
    return self;
}
@end
