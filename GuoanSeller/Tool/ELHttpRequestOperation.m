//
//  ELHttpRequestOperation.m
//  ElongtianRequest
//
//  Created by elongtian on 14-5-22.
//  Copyright (c) 2014年 elongtian. All rights reserved.
//

#import "ELHttpRequestOperation.h"

@implementation ELHttpRequestOperation
+ (instancetype)sharedClient {
    static ELHttpRequestOperation *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [ELHttpRequestOperation manager];
        [_sharedClient setResponseSerializer:[AFJSONResponseSerializer serializer]];
        [[_sharedClient responseSerializer] setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
        
    });
    return _sharedClient;
}

+ (void)getTokenAndTime{
 
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970];//秒
    NSString * recordtimeStr = [NSString stringWithFormat:@"%llu",recordTime];
    [[NSUserDefaults standardUserDefaults]setObject:recordtimeStr forKey:@"time"];
    NSString * valueStr = [NSUserDefaults_Token stringByAppendingString:NSUserDefaults_Time];
    valueStr = [FileMangerObject md5:valueStr];
    [[NSUserDefaults standardUserDefaults]setObject:valueStr forKey:@"token_md5"];
    
}

@end
