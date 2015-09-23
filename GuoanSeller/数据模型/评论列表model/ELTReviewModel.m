//
//  ELTReviewModel.m
//  GuoanSeller
//
//  Created by elongtian on 15/9/15.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "ELTReviewModel.h"

@implementation ELTReviewModel
-(instancetype)initWithDic:(NSDictionary * )dic{
    
    self.evaluation_value  = OBJCREMARK(dic [ @"evaluation_value"]);
    if (![[dic objectForKey:@"link_name"] isEqual:[NSNull null]] &&
        [[dic objectForKey:@"link_name"] isKindOfClass:[NSDictionary class]]
        ) {
        for (NSString * str in [[dic objectForKey:@"link_name"] allKeys]) {
            if ([str isEqualToString:@"service_name"]) {
                self.service_name =OBJCREMARK([dic objectForKey:@"link_name"] [ @"service_name"]);
                break;
            }
            if ([str isEqualToString:@"content_name"]) {
                self.service_name =OBJCREMARK([dic objectForKey:@"link_name"] [ @"content_name"]);
                break;
            }
        }
    }
    self.evaluation_content  = OBJCREMARK(dic [ @"evaluation_content"]);
    self.content_user  = OBJCREMARK(dic [ @"content_user"]);
    self.create_time  = OBJCREMARK(dic [ @"create_time"]);
    return self;
}
@end
