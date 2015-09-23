//
//  ELTCommentListModel.m
//  GuoanSeller
//
//  Created by elongtian on 15/9/15.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "ELTCommentListModel.h"
#import "RadioModel.h"
#import "ELTReviewModel.h"
@implementation ELTCommentListModel
-(instancetype)initWithDic:(NSDictionary * )dic{
    
    self.review= [NSMutableArray array];
    NSArray * arr = dic.allKeys;
    for (NSInteger i =0 ; i < arr.count; i ++) {
        if ([arr[i] isEqualToString:@"review"]) {
            if (![dic[@"review"] isEqual:[NSNull null]]) {
                for (NSDictionary * dict in dic[@"review"]) {
                    [self.review addObject:[ELTReviewModel ModelWithDic:dict]];
                }
            }
        }
    }
   

     self.radio = [NSMutableArray array];
    if (dic[@"radio"]) {
        for (NSDictionary * dict in dic[@"radio"]) {
            [self.radio addObject:[RadioModel ModelWithDic:dict]];
        }
    }
    return self;
}

@end
